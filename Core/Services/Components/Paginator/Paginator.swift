//
//  Paginator.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Action
import TRON
import SwiftyJSON

open class Paginator<ModelType> : BasePaginator<ModelType, Page<ModelType>> {
    public override init(factory: @escaping Func<Int, Observable<Page<ModelType>>>,
                         accomulationStrategy: @escaping ([ModelType], Page<ModelType>) -> [ModelType] = PaginationViewModelStrategies.Accomulations.additive,
                         compareStrategy: @escaping ([ModelType], [ModelType]) -> Bool = PaginationViewModelStrategies.Comparations.alwaysFails) {
        super.init(factory: factory, accomulationStrategy: accomulationStrategy, compareStrategy: compareStrategy)
    }
}

open class BasePaginator<ModelType, PageType: PaginatedResponseProtocol>: WorkerType where PageType.ContentType == ModelType {
    public let refreshTrigger = PublishRelay<Void>()
    public let loadNextPageTrigger = PublishRelay<Void>()
    
    public let elements = Variable<[ModelType]>([])
    public let error: Driver<Error>
    
    public var isLoadedOnce: Driver<Bool> {
        return elements.asDriver().skip(1).map{ _ in true }.startWith(false)
    }
    public let isEnabled = Variable(true)
    public let isWorking: Driver<Bool>
    
    public var accumulationStrategy: (_ current: [ModelType], _ page: PageType) -> [ModelType]
    
    private let action: Action<Int, PageType>
    private let disposeBag = DisposeBag()
    
    public init(factory: @escaping Func<Int, Observable<PageType>>,
                accomulationStrategy: @escaping ([ModelType], PageType) -> [ModelType] = PaginationViewModelStrategies.Accomulations.additive,
                compareStrategy: @escaping ([ModelType], [ModelType]) -> Bool = PaginationViewModelStrategies.Comparations.alwaysFails)  {
        self.accumulationStrategy = accomulationStrategy
        action = Action(enabledIf: isEnabled.asObservable(), workFactory: factory)
        
        isWorking = action.executing.asDriver(onErrorJustReturn: false)
        action.elements.asDriver(onErrorDriveWith: .empty())
            .scan([], accumulator: accumulationStrategy).distinctUntilChanged(compareStrategy)
            .drive(elements).disposed(by: disposeBag)
        
        error = action.errors.asDriver(onErrorDriveWith: .empty())
            .flatMap { error -> Driver<Error> in
                switch error {
                case .underlyingError(let error):
                    return Driver.of(error)
                case .notEnabled:
                    return Driver.empty()
                }
        }
        
        loadNextPageTrigger.asObservable()
            .withLatestFrom(action.elements.map{ page -> (page:Int, total: Int) in (page: page.index, total: page.totalPages) })
            .flatMap { (page, total) -> Observable<Int> in total > page ?  Observable.of(page + 1) : Observable.empty() }
            .bind(to: action.inputs)
            .disposed(by: disposeBag)
        
        refreshTrigger.asObservable().map { _ in 1 }.bind(to: action.inputs).disposed(by: disposeBag)
    }
}

public enum PaginationViewModelStrategies {
    public enum Accomulations {
        public static func excludeDuplicates<Page: PaginatedResponseProtocol> (content: [Page.ContentType], page: Page) -> [Page.ContentType] where Page.ContentType: Equatable {
            guard page.index != 1 else { return page.content }
            return content + page.content.filter({ !content.contains($0) })
        }
        public static func additive<Page: PaginatedResponseProtocol> (content: [Page.ContentType], page: Page) -> [Page.ContentType] {
            return page.index <= 1 ? page.content : content + page.content
        }
    }
    public enum Comparations {
        public static func alwaysFails<T>(content: [T], page: [T]) -> Bool {
            return false
        }
    }
}

public protocol PaginatedResponseProtocol {
    associatedtype ContentType
    var content: [ContentType] { get }
    var index: Int { get }
    var totalPages: Int { get }
}

extension Page: PaginatedResponseProtocol { }
