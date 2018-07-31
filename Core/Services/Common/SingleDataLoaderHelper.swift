//
//  SingleDataLoaderHelper.swift
//  Core
//
//  Created by Oleg Petrychuk on 30.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

final class SingleDataLoaderHelper<Model>: ReactiveCompatible {
    private let reachabilityService: ReachabilityService
    private let apiSource: Func<Int, Response<Model, RequestError>>
    private let storageSource: Func<Int, Model??>
    private let updateStorage: Func<Model, Void>
    
    init(
        reachabilityService: ReachabilityService,
        apiSource: @escaping Func<Int, Response<Model, RequestError>>,
        storageSource: @escaping Func<Int, Model??>,
        updateStorage: @escaping Func<Model, Void>
    ) {
        self.reachabilityService = reachabilityService
        self.apiSource = apiSource
        self.storageSource = storageSource
        self.updateStorage = updateStorage
    }
    
    func loadModel(byID id: Int) -> Response<Model, RequestError> {
        if reachabilityService.connection != .none {
            return loadAndUpdateData(byID: id)
        } else {
            return getStroedData(byID: id)
        }
    }
    
    private func getStroedData(byID id: Int) -> Response<Model, RequestError> {
        if let storedData = storageSource(id), let data = storedData {
            return .just(Result(value: data))
        } else {
            let errorMessage = "Can't find \(String(describing: Model.self)) object by id \(id)"
            let error = DictionaryError<RequestError>(key: NSLocalizedDescriptionKey, value: errorMessage)
            return .just(Result(error: error))
        }
    }
    
    private func loadAndUpdateData(byID id: Int) -> Response<Model, RequestError> {
        let request = apiSource(id)
        request.success().drive(onNext: { [weak self] in
            self?.updateStorage($0)
        }).disposed(by: rx.disposeBag)
        return request
    }
}
