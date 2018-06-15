//
//  API.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TRON

public typealias ResponseModel<T, U: BackendError> = Result<T, DictionaryError<U>>
public typealias Response<T, U: BackendError> = Driver<ResponseModel<T, U>>
public typealias Request<T, U: BackendError> = APIRequest<T, DictionaryError<U>>
public typealias UploadRequest<T, U: BackendError> = UploadAPIRequest<T, DictionaryError<U>>

open class API {
    public let tron: TRON
    public init(tron: TRON) {
        self.tron = tron
    }
}

public func defaultRecover<T>(error: Error) -> Driver<T> {
    assertionFailure(error.localizedDescription)
    return .empty()
}
