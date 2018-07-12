//
//  CDObject.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 11.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol CDObjectable {
    associatedtype PlainObject
    associatedtype CDObject: NSManagedObject
    static func new(conext: NSManagedObjectContext, plainObject: PlainObject) -> CDObject
    func compare(withPlainObject plainObject: PlainObject) -> Bool
    func toPlainObject() -> PlainObject
}
