//
//  Session.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TRON
import SwiftyJSON

public struct Session {
    public let token: String
    
    public init(token: String) throws {
        if token.isEmpty {
            throw "Token cannot be empty"
        }
        self.token = token
    }
}

extension Session: JSONDecodable {
    public init(json: JSON) throws {
        try self.init(
            token: json["auth_token"].string ?? "Missing token value".rethrow()
        )
    }
}
