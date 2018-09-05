//
//  Paginator.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Action

public final class Paginator<Model>: BasePaginator<Model, Page<Model>> {
    public override init (
        factory: @escaping Func<Int, Observable<Page<Model>>>,
        accomulationStrategy: @escaping ([Model], Page<Model>) -> [Model] = PaginationViewModelStrategies.Accomulations.additive,
        compareStrategy: @escaping ([Model], [Model]) -> Bool = PaginationViewModelStrategies.Comparations.alwaysFails
    ) {
        super.init(factory: factory, accomulationStrategy: accomulationStrategy, compareStrategy: compareStrategy)
    }
}

public class BasePaginator<Model, Page: PaginatedResponseType>: WorkerType where Page.Content == Model {
    public let elements = BehaviorRelay<[Model]>(value: [])
    public let error: Driver<Error>
    public let isLoadedOnce: Driver<Bool>
    public let isEnabled = BehaviorRelay(value: true)
    public let isWorking: Driver<Bool>
    public let noContent: Driver<Bool>
    
    public let refreshTrigger = PublishSubject<Void>()
    public let loadNextPageTrigger = PublishRelay<Void>()
    
    private let accumulationStrategy: (_ current: [Model], _ page: Page) -> [Model]
    private let action: Action<Int, Page>
    private let disposeBag = DisposeBag()
    
    public init(
        factory: @escaping Func<Int, Observable<Page>>,
        accomulationStrategy: @escaping ([Model], Page) -> [Model] = PaginationViewModelStrategies.Accomulations.additive,
        compareStrategy: @escaping ([Model], [Model]) -> Bool = PaginationViewModelStrategies.Comparations.alwaysFails
    ){
        self.accumulationStrategy = accomulationStrategy
        action = Action(enabledIf: isEnabled.asObservable(), workFactory: factory)
        isWorking = action.executing.asDriver(onErrorJustReturn: false)
        isLoadedOnce = elements.asDriver().skip(1).map(to: true).startWith(false)
        noContent = .combineLatest(isLoadedOnce, elements.asDriver().map { $0.isEmpty }) { $0 && $1 }
        refreshTrigger.asObservable().map(to: 1).bind(to: action.inputs).disposed(by: disposeBag)
        action.elements.asDriver(onErrorDriveWith: .empty())
            .scan([], accumulator: accumulationStrategy).distinctUntilChanged(compareStrategy)
            .drive(elements)
            .disposed(by: disposeBag)
        loadNextPageTrigger.asObservable()
            .withLatestFrom(action.elements.map{ page -> (page: Int, total: Int) in (page: page.index, total: page.totalPages) })
            .flatMap { (page, total) -> Observable<Int> in total > page ?  .of(page + 1) : .empty() }
            .bind(to: action.inputs)
            .disposed(by: disposeBag)
        error = action.errors.asDriver(onErrorDriveWith: .empty()).flatMap { error -> Driver<Error> in
            switch error {
            case .underlyingError(let error): return .of(error)
            case .notEnabled: return .empty()
            }
        }
    }
}
