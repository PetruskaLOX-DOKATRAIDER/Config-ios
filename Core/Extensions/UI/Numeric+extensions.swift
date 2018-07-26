//
//  Numeric+extensions.swift
//  Core
//
//  Created by Oleg Petrychuk on 26.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public extension Numeric {
    public func zeroIsNil() -> Self? {
        return self == 0 ? nil : self
    }
}
