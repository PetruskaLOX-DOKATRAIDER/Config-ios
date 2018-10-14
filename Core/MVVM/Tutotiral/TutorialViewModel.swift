//
//  TutorialViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 18.06.2018.
//Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol TutorialViewModel {
    var items: Driver<[TutorialItemViewModel]> { get }
    var navigationTitle: Driver<String> { get }
    var currentPage: Driver<Int> { get }
    var isMoveBackAvailable: Driver<Bool> { get }
    var pageTrigger: PublishSubject<Int> { get }
    var nextTrigger: PublishSubject<Void> { get }
    var skipTrigger: PublishSubject<Void> { get }
    var closeTrigger: PublishSubject<Void> { get }
    var shouldRouteApp: Driver<Void> { get }
    var shouldClose: Driver<Void> { get }
}

public final class TutorialViewModelImpl: TutorialViewModel, ReactiveCompatible {
    public let items: Driver<[TutorialItemViewModel]>
    public let navigationTitle: Driver<String>
    public let currentPage: Driver<Int>
    public let isMoveBackAvailable: Driver<Bool>
    public let pageTrigger = PublishSubject<Int>()
    public let nextTrigger = PublishSubject<Void>()
    public let skipTrigger = PublishSubject<Void>()
    public let closeTrigger = PublishSubject<Void>()
    public let shouldRouteApp: Driver<Void>
    public let shouldClose: Driver<Void>
    
    public init(userStorage: UserStorage) {
        let items = [
            TutorialItemViewModelImpl(title: Strings.Tutorial.Item1.title, description: Strings.Tutorial.Item1.description, coverImage: Images.Tutorial.tutorial1),
            TutorialItemViewModelImpl(title: Strings.Tutorial.Item2.title, description: Strings.Tutorial.Item2.description, coverImage: Images.Tutorial.tutorial2),
            TutorialItemViewModelImpl(title: Strings.Tutorial.Item3.title, description: Strings.Tutorial.Item3.description, coverImage: Images.Tutorial.tutorial3),
            TutorialItemViewModelImpl(title: Strings.Tutorial.Item4.title, description: Strings.Tutorial.Item4.description, coverImage: Images.Tutorial.tutorial4),
            TutorialItemViewModelImpl(title: Strings.Tutorial.Item5.title, description: Strings.Tutorial.Item5.description, coverImage: Images.Tutorial.tutorial5)
        ]
        self.items = .just(items)
        isMoveBackAvailable = userStorage.isOnboardingPassed.asDriver().map{ !$0 }
        
        let page = pageTrigger.startWith(0)
        navigationTitle = pageTrigger
            .map{ $0 == items.count - 1 ? Strings.Tutorial.start : Strings.Tutorial.next }
            .startWith(Strings.Tutorial.next).asDriver(onErrorJustReturn: "")
        let nextPage = nextTrigger.withLatestFrom( page ).map{ $0 == items.count - 1 ? $0 : $0 + 1 }
        currentPage = Observable.merge(page, nextPage).asDriver(onErrorJustReturn: 0)
        
        let nextStage = Observable.merge(
            nextTrigger.withLatestFrom( page ).filter{ $0 == items.count - 1 }.toVoid(),
            skipTrigger
        ).asDriver(onErrorJustReturn: ())

        shouldClose = .merge(
            closeTrigger.asDriver(onErrorJustReturn: ()),
            nextStage.filter{ userStorage.isOnboardingPassed.value }
        )
        
        shouldRouteApp = nextStage.filter{ !userStorage.isOnboardingPassed.value }
        shouldRouteApp.map(to: true).drive(userStorage.isOnboardingPassed).disposed(by: rx.disposeBag)
    }
}
