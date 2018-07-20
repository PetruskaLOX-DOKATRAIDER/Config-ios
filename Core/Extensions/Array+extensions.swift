//
//  Array+extensions.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension Sequence {
    public func allMatch(_ matcher: (Self.Iterator.Element) -> Bool) -> Bool {
        return first(where: { !matcher($0) }) == nil
    }
}

extension Collection {
    public subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array where Element: Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
}
