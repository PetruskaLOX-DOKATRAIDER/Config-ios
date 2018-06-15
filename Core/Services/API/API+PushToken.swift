//
//  API+PushToken.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import SwiftyJSON
import TRON

public protocol PushTokenServiceType: AutoMockable {
    func register(token: String) -> Response<Void, String>
}

extension API {
    public class PushTokenService: API, PushTokenServiceType {
        public func register(token: String) -> Response<Void, String>  {
            let request: Request<Void, String> = tron.request("profile", responseSerializer: VoidSerializationFactory())
            request.method = .patch
            request.parameters["profile[device_id]"] = "ios"
            request.parameters["profile[device_token]"] = token
            request.authorizationRequirement = .required
            return request.asResult()
        }
    }
}
