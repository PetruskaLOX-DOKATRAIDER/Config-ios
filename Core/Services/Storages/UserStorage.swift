//
//  UserStorage.swift
//  Core
//
//  Created by Oleg Petrychuk on 18.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol UserStorage: AutoMockable {
    var isOnboardingPassed: BehaviorRelay<Bool> { get }
    var email: BehaviorRelay<String?> { get }
}

public final class UserStorageImpl: UserStorage, ReactiveCompatible {
    enum Keys: String {
        case isOnboardingPassed = "UserStorageImpl.isOnboardingPassed.key"
        case email = "UserStorageImpl.email.key"
    }
    
    public let isOnboardingPassed: BehaviorRelay<Bool>
    public let email: BehaviorRelay<String?>
    
    public init(storage: Storage = UserDefaults.standard) {
        isOnboardingPassed = BehaviorRelay(value: storage.bool(forKey: Keys.isOnboardingPassed.rawValue))
        email = BehaviorRelay(value: storage.string(forKey: Keys.email.rawValue))
        
        isOnboardingPassed.asDriver().drive(onNext: { passed in
            storage.set(passed, forKey: Keys.isOnboardingPassed.rawValue)
        }).disposed(by: rx.disposeBag)
        email.asDriver().drive(onNext: { email in
            storage.set(email, forKey: Keys.email.rawValue)
        }).disposed(by: rx.disposeBag)
    }
}
