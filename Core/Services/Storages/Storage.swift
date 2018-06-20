//
//  Storage.swift
//  Core
//
//  Created by Oleg Petrychuk on 18.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// MARK: Protocol

public protocol Storage {
    func bool(forKey defaultName: String) -> Bool
    func set(_ value: Any?, forKey defaultName: String)
}

// MARK: Implementation

extension UserDefaults: Storage {}

// MARK: Factory

public class StorageFactory {
    public static func `default`() -> Storage {
        return UserDefaults.standard
    }
}
