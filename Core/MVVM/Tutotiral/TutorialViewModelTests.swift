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
            let userStorage = UserStorageMock(isOnboardingPassed: BehaviorRelay(value: false), email: BehaviorRelay(value: nil))
            var sut: TutorialViewModel!
            
            beforeEach {
                sut = TutorialViewModelImpl(userStorage: userStorage)
            }
            
            describe("when ask tutorial items") {
                it("should return valid count of items") {
                    try? expect(sut.items.toBlocking().first()?.count).to(equal(5))
                }
            }
            
            describe("when ask navigation title") {
                let observer = self.scheduler.createObserver(String.self)
                beforeEach {
                    sut.navigationTitle.drive(observer).disposed(by: self.disposeBag)
                }

                context("on start") {
                    it("should return 'Next'") {
                        try? expect(sut.navigationTitle.toBlocking().first()).to(equal(Strings.Tutorial.next))
                    }
                }
                
                context("when not last page did trigger") {
                    it("should return 'Next'") {
                        sut.pageTrigger.onNext(0)
                        try? expect(sut.navigationTitle.toBlocking().first()).to(equal(Strings.Tutorial.next))
                        
                        sut.pageTrigger.onNext(2)
                        try? expect(sut.navigationTitle.toBlocking().first()).to(equal(Strings.Tutorial.next))
                        
                        sut.pageTrigger.onNext(1)
                        try? expect(sut.navigationTitle.toBlocking().first()).to(equal(Strings.Tutorial.next))
                    }
                }

                context("when last page did trigger") {
                    it("should return 'Start'") {
                        sut.pageTrigger.onNext(4)
                        try? expect(sut.navigationTitle.toBlocking(timeout: 1).first()).to(equal(Strings.Tutorial.start))
                    }
                }
            }
            
            describe("when ask current page") {
                let observer = self.scheduler.createObserver(Int.self)
                beforeEach {
                    sut.currentPage.drive(observer).disposed(by: self.disposeBag)
                }
                
                context("on start") {
                    it("should return 0") {
                        try? expect(sut.currentPage.toBlocking().first()).to(equal(0))
                    }
                }
                
                context("when calling some page did trigger") {
                    it("should return valid number") {
                        sut.pageTrigger.onNext(0)
                        try? expect(sut.currentPage.toBlocking().first()).to(equal(0))
                        
                        sut.pageTrigger.onNext(1)
                        try? expect(sut.currentPage.toBlocking().first()).to(equal(1))
                        
                        sut.pageTrigger.onNext(1)
                        sut.pageTrigger.onNext(2)
                        try? expect(sut.currentPage.toBlocking().first()).to(equal(2))
                    }
                }
            }
            
            describe("when calling close did trigger") {
                let closeObserver = self.scheduler.createObserver(Void.self)
                let appObserver = self.scheduler.createObserver(Void.self)
                beforeEach {
                    sut.shouldClose.drive(closeObserver).disposed(by: self.disposeBag)
                    sut.shouldRouteApp.drive(appObserver).disposed(by: self.disposeBag)
                }
                
                context("and onbording is passed") {
                    it("should close") {
                        userStorage.isOnboardingPassed.accept(true)
                        
                        sut.skipTrigger.onNext(())
                        
                        expect(closeObserver.events.count).to(equal(1))
                        expect(appObserver.events.count).to(equal(0))
                    }
                }
                
                context("and onbording isn't passed") {
                    beforeEach {
                        userStorage.isOnboardingPassed.accept(false)
                        sut.skipTrigger.onNext(())
                    }
                    
                    it("should go to app") {
                        expect(closeObserver.events.count).to(equal(2))
                        expect(appObserver.events.count).to(equal(1))
                    }
                    
                    it("should save onboarding status as passed") {
                        expect(userStorage.isOnboardingPassed.value).to(beTruthy())
                    }
                }
            }
            
            describe("when calling next did trigger") {
                let currentPageObserver = self.scheduler.createObserver(Int.self)
                beforeEach {
                    sut.currentPage.drive(currentPageObserver).disposed(by: self.disposeBag)
                }
                
                it("should return valid current page") {
                    sut.nextTrigger.onNext(())
                    try? expect(sut.currentPage.toBlocking().first()).to(equal(1))
                    
                    sut.pageTrigger.onNext(2)
                    sut.nextTrigger.onNext(())
                    try? expect(sut.currentPage.toBlocking().first()).to(equal(3))
                }
            }
            
            describe("when ask is move back avaliable") {
                let isMoveBackAvailableObserver = self.scheduler.createObserver(Bool.self)
                beforeEach {
                    sut.isMoveBackAvailable.drive(isMoveBackAvailableObserver).disposed(by: self.disposeBag)
                }
                
                context("and onboarding is not passed") {
                    it("should return avaliable") {
                        userStorage.isOnboardingPassed.accept(false)
                        try? expect(sut.isMoveBackAvailable.toBlocking().first()).to(beTruthy())
                    }
                }
                
                context("and onboarding is passed") {
                    it("should return unavailable") {
                        userStorage.isOnboardingPassed.accept(true)
                        try? expect(sut.isMoveBackAvailable.toBlocking().first()).to(beFalsy())
                    }
                }
            }
        }
    }
}
