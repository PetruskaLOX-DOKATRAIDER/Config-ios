//
//  Storage.swift
//  Core
//
//  Created by Oleg Petrychuk on 18.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol Storage {
    func bool(forKey defaultName: String) -> Bool
    func object(forKey defaultName: String) -> Any?
    func string(forKey defaultName: String) -> String?
    func double(forKey defaultName: String) -> Double
    func integer(forKey defaultName: String) -> Int
    func set(_ value: Double, forKey defaultName: String)
    func set(_ value: Any?, forKey defaultName: String)
    func set(_ value: Int, forKey defaultName: String)
}

extension UserDefaults: Storage {}
