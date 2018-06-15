//
//  HeaderFactory.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TRON
import Alamofire

struct AuthorizationRequestAdapter : RequestAdapter {
    
    let tokenStorage: SessionStorageType
    
    init(tokenStorage: SessionStorageType) {
        self.tokenStorage = tokenStorage
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        if let token = tokenStorage.session.value?.token {
            urlRequest.addValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
        }
        return urlRequest
    }
}
