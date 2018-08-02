//
//  Error+extensions.swift
//  Core
//
//  Created by Oleg Petrychuk on 15.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension Error {
    public func rethrow<T>() throws -> T {
        throw self
    }
    
    public static func new(
        domain: String = "unknown",
        code: Int = 0,
        localizedDescription: String
    ) -> Error {
        return Self.new(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
    
    public static func new(
        domain: String = "unknown",
        code: Int = 0,
        userInfo: [String : Any]? = nil
    ) -> Error {
        return NSError(domain: domain, code: code, userInfo: userInfo) as Error
    }
}

extension String: Error {}
