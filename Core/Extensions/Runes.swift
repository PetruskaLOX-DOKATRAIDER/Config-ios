//
//  Runes.swift
//  Core
//
//  Created by Oleg Petrychuk on 18.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

precedencegroup RunesMonadicPrecedenceLeft {
    associativity: left
    lowerThan: LogicalDisjunctionPrecedence
    higherThan: AssignmentPrecedence
}

infix operator >>- : RunesMonadicPrecedenceLeft

public func >>- <T, U>(a: T?, f: (T) -> U?) -> U? {
    return a.flatMap(f)
}
