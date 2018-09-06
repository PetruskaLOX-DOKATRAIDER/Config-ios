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

final class TutorialViewModelImpl: TutorialViewModel, ReactiveCompatible {
    let items: Driver<[TutorialItemViewModel]>
    let navigationTitle: Driver<String>
    let currentPage: Driver<Int>
    let isMoveBackAvailable: Driver<Bool>
    let pageTrigger = PublishSubject<Int>()
    let nextTrigger = PublishSubject<Void>()
    let skipTrigger = PublishSubject<Void>()
    let closeTrigger = PublishSubject<Void>()
    let shouldRouteApp: Driver<Void>
    let shouldClose: Driver<Void>
    
    init(userStorage: UserStorage) {
        let items = [
            TutorialItemViewModelImpl(title: Strings.Tutorial.Item1.title, description: Strings.Tutorial.Item1.description, coverImage: Images.Tutorial.tutorial1),
            TutorialItemViewModelImpl(title: Strings.Tutorial.Item2.title, description: Strings.Tutorial.Item2.description, coverImage: Images.Tutorial.tutorial2),
            TutorialItemViewModelImpl(title: Strings.Tutorial.Item3.title, description: Strings.Tutorial.Item3.description, coverImage: Images.Tutorial.tutorial3),
            TutorialItemViewModelImpl(title: Strings.Tutorial.Item4.title, description: Strings.Tutorial.Item4.description, coverImage: Images.Tutorial.tutorial4)
        ]
        self.items = .just(items)
        isMoveBackAvailable = userStorage.isOnboardingPassed.asDriver().map{ !$0 }
        
        let page = pageTrigger.startWith(0)
        navigationTitle = pageTrigger
            .map{ $0 == items.count - 1 ? Strings.Tutorial.start : Strings.Tutorial.next }
            .startWith(Strings.Tutorial.next).asDriver(onErrorJustReturn: "")
        let nextPage = nextTrigger.withLatestFrom(page).map{ currentPage in
            return (currentPage == items.count - 1) ? currentPage : currentPage + 1
        }
        currentPage = Observable.merge(page, nextPage).asDriver(onErrorJustReturn: 0)
        
        let nextStage = Observable.merge(
            nextTrigger.withLatestFrom(page).filter{ $0 == items.count - 1 }.toVoid(),
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
