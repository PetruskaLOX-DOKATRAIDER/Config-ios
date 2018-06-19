//
//  UserStorage.swift
//  Core
//
//  Created by Oleg Petrychuk on 18.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// MARK: Protocol

public protocol UserStorage {
    var isOnboardingPassed: BehaviorRelay<Bool> { get }
}

// MARK: Implementation

private final class UserStorageImpl: UserStorage, ReactiveCompatible {
    enum Keys: String {
        case isOnboardingPassed = "UserStorageImpl.isOnboardingPassed.key"
    }
    
    public let isOnboardingPassed: BehaviorRelay<Bool>
    
    init(storage: Storage) {
        isOnboardingPassed = BehaviorRelay(value: storage.bool(forKey: Keys.isOnboardingPassed.rawValue))
        isOnboardingPassed.asDriver().drive(onNext: { passed in
            storage.set(passed, forKey: Keys.isOnboardingPassed.rawValue)
        }).disposed(by: rx.disposeBag)
    }
}

// MARK: Factory

public class UserStorageFactory {
    public static func `default`(
        storage: Storage = StorageFactory.default()
    ) -> UserStorage {
        return UserStorageImpl(storage: storage)
    }
}
