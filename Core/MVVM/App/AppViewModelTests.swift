//
//  AppViewModelTests.swift
//  GoDrive
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class AppViewModelTests: BaseTestCase {
    override func spec() {
        describe("AppViewModel") {
            var sut: AppViewModel!
            let userStorage = UserStorageMock(isOnboardingPassed: BehaviorRelay(value: false), email: BehaviorRelay(value: nil))
            
            beforeEach {
                sut = AppViewModelImpl(userStorage: userStorage)
            }
            
            describe("when did become active trigger", {
                let tutorialObserver = self.scheduler.createObserver(Void.self)
                let appObserver = self.scheduler.createObserver(Void.self)
                beforeEach {
                    sut.shouldRouteTutorial.drive(tutorialObserver).disposed(by: self.disposeBag)
                    sut.shouldRouteApp.drive(appObserver).disposed(by: self.disposeBag)
                }
                
                context("and onboarding is passed") {
                    it("should route to app", closure: {
                        userStorage.isOnboardingPassed.accept(true)
                        sut.didBecomeActiveTrigger.onNext(())
                        expect(tutorialObserver.events.count).to(equal(0))
                        expect(appObserver.events.count).to(equal(1))
                    })
                }
                context("and onboarding is not passed") {
                    it("should route to tutorial", closure: {
                        userStorage.isOnboardingPassed.accept(false)
                        sut.didBecomeActiveTrigger.onNext(())
                        expect(tutorialObserver.events.count).to(equal(1))
                        expect(appObserver.events.count).to(equal(1))
                    })
                }
            })
        }
    }
}
