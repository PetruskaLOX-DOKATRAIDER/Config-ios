//
//  Request+extensions.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TRON

public extension APIRequest where ErrorModel: Error & StatusCodeContainable {
    public func asResult(recover: @escaping Func<Error, Driver<Result<Model, ErrorModel>>> = defaultRecover) -> Driver<Result<Model, ErrorModel>> {
        return Observable.create({ observer in
            let token = self.perform(withSuccess: { result in
                observer.onNext(Result(value: result))
                observer.onCompleted()
            }, failure: { error in
                if var errorModel = error.errorModel {
                    errorModel.statusCode = error.response?.statusCode
                    observer.onNext(Result(error: errorModel))
                    observer.onCompleted()
                } else {
                    observer.onError(error)
                }
            })
            return Disposables.create {
                token?.cancel()
            }
        }).asDriver(onErrorRecover: recover)
    }
}

extension UploadAPIRequest where ErrorModel: Error {
    open func asResult(recover: @escaping Func<Error, Driver<Result<Model, ErrorModel>>> = defaultRecover) -> Driver<Result<Model, ErrorModel>> {
        return Observable.create({ observer in
            var request : AlamofireRequest?
            self.performMultipart(withSuccess: { result in
                observer.onNext(Result(value: result))
                observer.onCompleted()
            }, failure: { error in
                if let error = error.errorModel {
                    observer.onNext(Result(error: error))
                    observer.onCompleted()
                } else {
                    observer.onError(error)
                }
            }, encodingCompletion : { completion in
                switch completion {
                case .success(let originalRequest, _, _): request = originalRequest
                case .failure(let error): observer.onError(error)
                }
            })
            return Disposables.create {
                request?.cancel()
            }
        }).asDriver(onErrorRecover: recover)
    }
}
