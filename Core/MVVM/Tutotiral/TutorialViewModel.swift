//
//  TutorialViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 18.06.2018.
//Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// MARK: Protocol

public protocol TutorialViewModel {
    var items: Driver<[TutorialItemViewModel]> { get }
    var navigationTitle: Driver<String> { get }
    var currentPage: Driver<Int> { get }
    var pageTrigger: PublishSubject<Int> { get }
    var nextTrigger: PublishSubject<Void> { get }
    var skipTrigger: PublishSubject<Void> { get }
    var shouldRouteApp: Driver<Void> { get }
    var shouldRouteSettings: Driver<Void> { get }
    var isMoveBackAvailable: Driver<Bool> { get }
}

// MARK: Implementation

private final class TutorialViewModelImpl: TutorialViewModel {
    public let items: Driver<[TutorialItemViewModel]>
    public let navigationTitle: Driver<String>
    public let currentPage: Driver<Int>
    public let pageTrigger = PublishSubject<Int>()
    public let nextTrigger = PublishSubject<Void>()
    public let skipTrigger = PublishSubject<Void>()
    public let shouldRouteApp: Driver<Void>
    public let shouldRouteSettings: Driver<Void>
    public let isMoveBackAvailable: Driver<Bool>
    
    public init(userStorage: UserStorage) {
        let items = [
            TutorialItemViewModelFactory.default(title: Strings.Tutorial.Item1.title, description: Strings.Tutorial.Item1.description, coverImage: Images.Tutorial.tutorial1),
            TutorialItemViewModelFactory.default(title: Strings.Tutorial.Item2.title, description: Strings.Tutorial.Item2.description, coverImage: Images.Tutorial.tutorial2),
            TutorialItemViewModelFactory.default(title: Strings.Tutorial.Item3.title, description: Strings.Tutorial.Item3.description, coverImage: Images.Tutorial.tutorial3),
            TutorialItemViewModelFactory.default(title: Strings.Tutorial.Item4.title, description: Strings.Tutorial.Item4.description, coverImage: Images.Tutorial.tutorial4)
        ]
        let page = pageTrigger.startWith(0)
        navigationTitle = pageTrigger.map{ $0 == items.count - 1 ? Strings.Tutorial.start : Strings.Tutorial.next }.startWith(Strings.Tutorial.next).asDriver(onErrorJustReturn: "")
        let nextPage = nextTrigger.withLatestFrom(page).map{ $0 == items.count - 1 ? $0 : $0 + 1 }
        currentPage = Observable.merge(page, nextPage).asDriver(onErrorJustReturn: 0)
        let nextStage = Observable.merge(nextTrigger.withLatestFrom(page).filter{ $0 == items.count - 1 }.toVoid(), skipTrigger).asDriver(onErrorJustReturn: ())
        shouldRouteSettings = nextStage.filter{ userStorage.isOnboardingPassed.value }
        shouldRouteApp = nextStage.filter{ !userStorage.isOnboardingPassed.value }
        isMoveBackAvailable = userStorage.isOnboardingPassed.asDriver().map{ !$0 }
        self.items = .just(items)
    }
}

// MARK: Factory

public class TutorialViewModelFactory {
    public static func `default`(
        userStorage: UserStorage = UserStorageFactory.default()
    ) -> TutorialViewModel {
        return TutorialViewModelImpl(userStorage: userStorage)
    }
}
