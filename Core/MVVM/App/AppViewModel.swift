//
//  AppViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol AppViewModel {
    var didBecomeActiveTrigger: PublishSubject<Void> { get }
    var shouldRouteTutorial: Driver<Void> { get }
    var shouldRouteApp: Driver<Void> { get }
}

public final class AppViewModelImpl: AppViewModel {
    public let didBecomeActiveTrigger = PublishSubject<Void>()
    public let shouldRouteTutorial: Driver<Void>
    public let shouldRouteApp: Driver<Void>
    
    public init(userStorage: UserStorage) {
        let isOnboardingPassed = didBecomeActiveTrigger.map{ userStorage.isOnboardingPassed.value }.asDriver(onErrorJustReturn: true)
        shouldRouteTutorial = isOnboardingPassed.filter{ !$0 }.toVoid()
        shouldRouteApp = isOnboardingPassed.filter{ $0 }.toVoid()
    }
}
