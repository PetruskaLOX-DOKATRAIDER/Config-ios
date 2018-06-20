//
//  AppViewModelTests.swift
//  GoDrive
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Quick
import Nimble
import Core
import TestsHelper

class AppViewModelTests: BaseTestCase {
    override func spec() {
        describe("AppViewModel") {
            var sut: AppViewModel!
            let userStorage = UserStorageMock(isOnboardingPassed: BehaviorRelay(value: false))
            
            beforeEach {
                sut = AppViewModelFactory.default(userStorage: userStorage)
            }
            
            describe("when did become active trigger", {
                let shouldRouteTutorialObserver = self.scheduler.createObserver(Void.self)
                let shouldRouteAppObserver = self.scheduler.createObserver(Void.self)
                beforeEach {
                    sut.shouldRouteTutorial.drive(shouldRouteTutorialObserver).disposed(by: self.disposeBag)
                    sut.shouldRouteApp.drive(shouldRouteAppObserver).disposed(by: self.disposeBag)
                }
                
                context("and onboarding is passed") {
                    it("should route to app", closure: {
                        userStorage.isOnboardingPassed.accept(true)
                        sut.didBecomeActiveTrigger.onNext(())
                        expect(shouldRouteTutorialObserver.events.count).to(equal(0))
                        expect(shouldRouteAppObserver.events.count).to(equal(1))
                    })
                }
                context("and onboarding is not passed") {
                    it("should route to tutorial", closure: {
                        userStorage.isOnboardingPassed.accept(false)
                        sut.didBecomeActiveTrigger.onNext(())
                        expect(shouldRouteTutorialObserver.events.count).to(equal(1))
                        expect(shouldRouteAppObserver.events.count).to(equal(1))
                    })
                }
            })
        }
    }
}
