//
//  AppViewModel.swift
//  GoDrive
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// MARK: Protocol

public protocol AppViewModel {
    var didBecomeActiveTrigger: PublishSubject<Void> { get }
    var shouldRouteTutorial: Driver<Void> { get }
    var shouldRouteApp: Driver<Void> { get }
}

// MARK: Implementation

private final class AppViewModelImpl: AppViewModel {
    let didBecomeActiveTrigger = PublishSubject<Void>()
    let shouldRouteTutorial: Driver<Void>
    let shouldRouteApp: Driver<Void>
    
    init(userStorage: UserStorage) {
        let isOnboardingPassed = didBecomeActiveTrigger.map{ userStorage.isOnboardingPassed.value }.asDriver(onErrorJustReturn: true)
        shouldRouteTutorial = isOnboardingPassed.filter{ !$0 }.toVoid()
        shouldRouteApp = isOnboardingPassed.filter{ $0 }.toVoid()
    }
}

// MARK: Factory

public class AppViewModelFactory {
    public static func `default`(
        userStorage: UserStorage = UserStorageFactory.default()
    ) -> AppViewModel {
        return AppViewModelImpl(userStorage: userStorage)
    }
}
