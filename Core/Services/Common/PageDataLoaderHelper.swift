//
//  LoaderHelper.swift
//  Core
//
//  Created by Oleg Petrychuk on 12.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

final class PageDataLoaderHelper<Model>: ReactiveCompatible {
    private let reachabilityService: ReachabilityService
    private let apiSource: Func<Int, Response<Page<Model>, RequestError>>
    private let storageSource: Driver<[Model]>
    private let updateStorage: Func<[Model], Void>
    
    init(
        reachabilityService: ReachabilityService,
        apiSource: @escaping Func<Int, Response<Page<Model>, RequestError>>,
        storageSource: @escaping Func<Void, [Model]?>,
        updateStorage: @escaping Func<[Model], Void>
    ) {
        self.reachabilityService = reachabilityService
        self.apiSource = apiSource
        self.storageSource = storageSource
        self.updateStorage = updateStorage
    }
    
    func loadData(forPage page: Int) -> Response<Page<Model>, RequestError> {
        if reachabilityService.connection != .none {
            return loadAndUpdateData(forPage: page)
        } else {
            return getStroedData()
        }
    }
    
    private func getStroedData() -> Response<Page<Model>, RequestError> {
        let storedData = storageSource(()) ?? []
        let page = Page<Model>.new(content: storedData, index: 0, totalPages: 0)
        return .just(Result(value: page))
    }
    
    private func loadAndUpdateData(forPage page: Int) -> Response<Page<Model>, RequestError> {
        let request = apiSource(page)
        request.success().drive(onNext: { [weak self] in
            var content = [Model]()
            for _ in 1...10000 {
                $0.content.forEach({ (mod) in
                    content.append(mod)
                })
            }

            self?.updateStorage(content)
            //self?.updateStorage($0.content)
        }).disposed(by: rx.disposeBag)
        return request
    }
}
