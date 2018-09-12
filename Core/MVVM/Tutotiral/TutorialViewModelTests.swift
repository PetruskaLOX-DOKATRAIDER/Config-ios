//
//  TutorialViewModelTests.swift
//  Config
//
//  Created by Oleg Petrychuk on 18.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class TutorialViewModelTests: BaseTestCase {
    override func spec() {
        describe("TutorialViewModel") {
            var sut: TutorialViewModel!
            let userStorage = UserStorageMock(isOnboardingPassed: BehaviorRelay(value: false), email: BehaviorRelay(value: nil))
            
            beforeEach {
                sut = TutorialViewModelImpl(userStorage: userStorage)
            }
            
            describe("when ask tutorial items", {
                it("should return valid count of items", closure: {
                    try? expect(sut.items.toBlocking().first()?.count).to(equal(4))
                })
            })
            
            describe("when ask navigation title", {
                let navigationTitleObserver = self.scheduler.createObserver(String.self)
                beforeEach {
                    sut.navigationTitle.drive(navigationTitleObserver).disposed(by: self.disposeBag)
                }

                context("on start") {
                    it("should return next", closure: {
                        try? expect(sut.navigationTitle.toBlocking().first()).to(equal(Strings.Tutorial.next))
                    })
                }
                
                context("after not last page triggered") {
                    it("should return next", closure: {
                        sut.pageTrigger.onNext(0)
                        try? expect(sut.navigationTitle.toBlocking().first()).to(equal(Strings.Tutorial.next))
                        sut.pageTrigger.onNext(2)
                        try? expect(sut.navigationTitle.toBlocking().first()).to(equal(Strings.Tutorial.next))
                        sut.pageTrigger.onNext(1)
                        try? expect(sut.navigationTitle.toBlocking().first()).to(equal(Strings.Tutorial.next))
                    })
                }

                context("after last page triggered") {
                    it("should return start", closure: {
                        sut.pageTrigger.onNext(3)
                        try? expect(sut.navigationTitle.toBlocking(timeout: 1).first()).to(equal(Strings.Tutorial.start))
                    })
                }
            })
            
            describe("when ask current page", {
                let currentPageObserver = self.scheduler.createObserver(Int.self)
                beforeEach {
                    sut.currentPage.drive(currentPageObserver).disposed(by: self.disposeBag)
                }
                
                context("on start") {
                    it("should return 0", closure: {
                        try? expect(sut.currentPage.toBlocking().first()).to(equal(0))
                    })
                }
                
                context("after some page triggered") {
                    it("should return valid number", closure: {
                        sut.pageTrigger.onNext(0)
                        try? expect(sut.currentPage.toBlocking().first()).to(equal(0))
                        sut.pageTrigger.onNext(1)
                        try? expect(sut.currentPage.toBlocking().first()).to(equal(1))
                        sut.pageTrigger.onNext(1)
                        sut.pageTrigger.onNext(2)
                        try? expect(sut.currentPage.toBlocking().first()).to(equal(2))
                    })
                }
            })
            
            describe("when skip trigger", {
                let closeObserver = self.scheduler.createObserver(Void.self)
                let appObserver = self.scheduler.createObserver(Void.self)
                beforeEach {
                    sut.shouldClose.drive(closeObserver).disposed(by: self.disposeBag)
                    sut.shouldRouteApp.drive(appObserver).disposed(by: self.disposeBag)
                }
                
                context("and onbording is passed") {
                    it("should close", closure: {
                        userStorage.isOnboardingPassed.accept(true)
                        sut.skipTrigger.onNext(())
                        expect(closeObserver.events.count).to(equal(1))
                        expect(appObserver.events.count).to(equal(0))
                    })
                }
                
                context("and onbording is not passed") {
                    beforeEach {
                        userStorage.isOnboardingPassed.accept(false)
                        sut.skipTrigger.onNext(())
                    }
                    
                    it("should route to app", closure: {
                        expect(closeObserver.events.count).to(equal(2))
                        expect(appObserver.events.count).to(equal(1))
                    })
                    
                    it("should save isOnboardingPassed as true", closure: {
                        expect(userStorage.isOnboardingPassed.value).to(beTruthy())
                    })
                }
            })
            
            describe("when next trigger", {
                let currentPageObserver = self.scheduler.createObserver(Int.self)
                beforeEach {
                    sut.currentPage.drive(currentPageObserver).disposed(by: self.disposeBag)
                }
                
                it("should move to current page", closure: {
                    sut.nextTrigger.onNext(())
                    try? expect(sut.currentPage.toBlocking().first()).to(equal(1))
                    sut.pageTrigger.onNext(2)
                    sut.nextTrigger.onNext(())
                    try? expect(sut.currentPage.toBlocking().first()).to(equal(3))
                })
            })
            
            describe("when ask is move back avaliable", {
                let isMoveBackAvailableObserver = self.scheduler.createObserver(Bool.self)
                beforeEach {
                    sut.isMoveBackAvailable.drive(isMoveBackAvailableObserver).disposed(by: self.disposeBag)
                }
                
                context("and onboarding is not passed") {
                    it("move back shouldn't be avaliable", closure: {
                        userStorage.isOnboardingPassed.accept(false)
                        try? expect(sut.isMoveBackAvailable.toBlocking().first()).to(beTruthy())
                    })
                }
                context("and onboarding is passed") {
                    it("move back should be avaliable", closure: {
                        userStorage.isOnboardingPassed.accept(true)
                        try? expect(sut.isMoveBackAvailable.toBlocking().first()).to(beFalsy())
                    })
                }
            })
        }
    }
}
