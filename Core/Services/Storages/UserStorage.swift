//
//  UserStorage.swift
//  Core
//
//  Created by Oleg Petrychuk on 18.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol UserStorage: AutoMockable {
    var isOnboardingPassed: BehaviorRelay<Bool> { get }
}

public final class UserStorageImpl: UserStorage, ReactiveCompatible {
    enum Keys: String {
        case isOnboardingPassed = "UserStorageImpl.isOnboardingPassed.key"
    }
    
    public let isOnboardingPassed: BehaviorRelay<Bool>
    
    public init(storage: Storage = StorageFactory.default()) {
        isOnboardingPassed = BehaviorRelay(value: storage.bool(forKey: Keys.isOnboardingPassed.rawValue))
        isOnboardingPassed.asDriver().drive(onNext: { passed in
            storage.set(passed, forKey: Keys.isOnboardingPassed.rawValue)
        }).disposed(by: rx.disposeBag)
    }
}
