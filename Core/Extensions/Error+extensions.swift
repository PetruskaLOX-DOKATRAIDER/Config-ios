//
//  Error+extensions.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension Error {
    public func rethrow<T>() throws -> T {
        throw self
    }
}

extension String: Error {
    
}
