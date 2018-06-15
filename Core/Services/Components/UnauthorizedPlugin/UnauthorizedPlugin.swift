//
//  UnauthorizedPlugin.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TRON
import Foundation
import Alamofire

//swiftlint:disable large_tuple

public protocol AuthPluginType: AutoMockable {
    var unauthorized: Driver<Void> { get }
    var unsupported: Driver<Void> { get }
}

open class UnauthorizedPlugin: Plugin, AuthPluginType {
    private let unauthorizedTrigger = PublishRelay<Void>()
    private let unsupportedTrigger = PublishRelay<Void>()
    
    open var unauthorized: Driver<Void> { return unauthorizedTrigger.asDriver() }
    open var unsupported: Driver<Void> { return unsupportedTrigger.asDriver() }
    
    public init() {}
    
    open func willProcessResponse<Model, ErrorModel>(response: (URLRequest?, HTTPURLResponse?, Data?, Error?), forRequest request: Alamofire.Request, formedFrom tronRequest: BaseRequest<Model, ErrorModel>) {
        guard let response = response.1, let errorStatus = ServerErrorStatus(rawValue: response.statusCode) else { return }
        switch errorStatus {
        case .unauthorized:
            unauthorizedTrigger.accept(())
        case .unsupportedVersion:
            unauthorizedTrigger.accept(())
            unsupportedTrigger.accept(())
        }
    }
}

public enum ServerErrorStatus: Int, Error {
    case unsupportedVersion = 479 // TODO: ask your backend developer about this status code, it may be different
    case unauthorized = 401
}
