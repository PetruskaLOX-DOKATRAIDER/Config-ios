//
//  TutorialViewModelTests.swift
//  Config
//
//  Created by Oleg Petrychuk on 18.06.2018.
//Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Quick
import Nimble
import Core
import TestsHelper

//class TutorialViewModelTests: BaseTestCase {
//    override func spec() {
//        describe("TutorialViewModel") {
//            var sut: TutorialViewModel!
//            let userStorage = UserStorageMock(isOnboardingPassed: BehaviorRelay(value: false))
//            
//            beforeEach {
//                sut = TutorialViewModelFactory.default(userStorage: userStorage)
//            }
//            
//            describe("when ask tutorial items", {
//                it("should return valid count of items", closure: {
//                    try? expect(sut.items.toBlocking().first()?.count).to(equal(4))
//                })
//            })
//            
//            describe("when ask navigation title", {
//                let navigationTitleObserver = self.scheduler.createObserver(String.self)
//                beforeEach {
//                    sut.navigationTitle.drive(navigationTitleObserver).disposed(by: self.disposeBag)
//                }
//
//                context("on start") {
//                    it("should return valid text", closure: {
//                        try? expect(sut.navigationTitle.toBlocking().first()).to(equal(Strings.Tutorial.next))
//                    })
//                }
//                
//                context("after first page triggered") {
//                    it("should return valid text", closure: {
//                        sut.pageTrigger.onNext(0)
//                        try? expect(sut.navigationTitle.toBlocking().first()).to(equal(Strings.Tutorial.next))
//                    })
//                }
//                
//                context("after second page triggered") {
//                    it("should return valid text", closure: {
//                        sut.pageTrigger.onNext(1)
//                        try? expect(sut.navigationTitle.toBlocking().first()).to(equal(Strings.Tutorial.next))
//                    })
//                }
//                
//                context("after third page triggered") {
//                    it("should return valid text", closure: {
//                        sut.pageTrigger.onNext(2)
//                        try? expect(sut.navigationTitle.toBlocking().first()).to(equal(Strings.Tutorial.next))
//                    })
//                }
//                
//                context("after second page triggered again") {
//                    it("should return valid text", closure: {
//                        sut.pageTrigger.onNext(1)
//                        try? expect(sut.navigationTitle.toBlocking().first()).to(equal(Strings.Tutorial.next))
//                    })
//                }
//                
//                context("after last page triggered") {
//                    it("should return valid text", closure: {
//                        sut.pageTrigger.onNext(3)
//                        try? expect(sut.navigationTitle.toBlocking(timeout: 1).first()).to(equal(Strings.Tutorial.start))
//                    })
//                }
//            })
//            
//            describe("when ask current page", {
//                let currentPageObserver = self.scheduler.createObserver(Int.self)
//                beforeEach {
//                    sut.currentPage.drive(currentPageObserver).disposed(by: self.disposeBag)
//                }
//                
//                context("on start") {
//                    it("should return valid number", closure: {
//                        try? expect(sut.currentPage.toBlocking().first()).to(equal(0))
//                    })
//                }
//                
//                context("after first page triggered") {
//                    it("should return valid number", closure: {
//                        sut.pageTrigger.onNext(0)
//                        try? expect(sut.currentPage.toBlocking().first()).to(equal(0))
//                    })
//                }
//                
//                context("after second page triggered") {
//                    it("should return valid number", closure: {
//                        sut.pageTrigger.onNext(1)
//                        try? expect(sut.currentPage.toBlocking().first()).to(equal(1))
//                    })
//                }
//                
//                context("after third page triggered") {
//                    it("should return valid number", closure: {
//                        sut.pageTrigger.onNext(1)
//                        sut.pageTrigger.onNext(2)
//                        try? expect(sut.currentPage.toBlocking().first()).to(equal(2))
//                    })
//                }
//                
//                context("after second page triggered again") {
//                    it("should return valid number", closure: {
//                        sut.pageTrigger.onNext(1)
//                        try? expect(sut.currentPage.toBlocking().first()).to(equal(1))
//                    })
//                }
//                
//                context("after last page triggered") {
//                    it("should return valid number", closure: {
//                        sut.pageTrigger.onNext(3)
//                        try? expect(sut.currentPage.toBlocking().first()).to(equal(3))
//                    })
//                }
//            })
//            
//            describe("when skip trigger", {
//                let routeSettingsObserver = self.scheduler.createObserver(Void.self)
//                let routeAppObserver = self.scheduler.createObserver(Void.self)
//                beforeEach {
//                    sut.shouldRouteSettings.drive(routeSettingsObserver).disposed(by: self.disposeBag)
//                    sut.shouldRouteApp.drive(routeAppObserver).disposed(by: self.disposeBag)
//                }
//                
//                context("and onbording is passed") {
//                    it("should route to settings", closure: {
//                        userStorage.isOnboardingPassed.accept(true)
//                        sut.skipTrigger.onNext(())
//                        expect(routeSettingsObserver.events.count).to(equal(1))
//                        expect(routeAppObserver.events.count).to(equal(0))
//                    })
//                }
//                
//                context("and onbording is not passed") {
//                    beforeEach {
//                        userStorage.isOnboardingPassed.accept(false)
//                        sut.skipTrigger.onNext(())
//                    }
//                    
//                    it("should route to app", closure: {
//                        expect(routeSettingsObserver.events.count).to(equal(2))
//                        expect(routeAppObserver.events.count).to(equal(1))
//                    })
//                    
//                    it("should save isOnboardingPassed as true", closure: {
//                        expect(userStorage.isOnboardingPassed.value).to(beTruthy())
//                    })
//                }
//            })
//            
//            describe("when next trigger", {
//                let currentPageObserver = self.scheduler.createObserver(Int.self)
//                beforeEach {
//                    sut.currentPage.drive(currentPageObserver).disposed(by: self.disposeBag)
//                }
//                
//                context("and current page is 0") {
//                    it("should move to second page", closure: {
//                        sut.nextTrigger.onNext(())
//                        try? expect(sut.currentPage.toBlocking().first()).to(equal(1))
//                    })
//                }
//                context("and current page is 2") {
//                    it("should move to third page", closure: {
//                        sut.pageTrigger.onNext(2)
//                        sut.nextTrigger.onNext(())
//                        try? expect(sut.currentPage.toBlocking().first()).to(equal(3))
//                    })
//                }
//            })
//            
//            describe("when ask is move back avaliable", {
//                let isMoveBackAvailableObserver = self.scheduler.createObserver(Bool.self)
//                beforeEach {
//                    sut.isMoveBackAvailable.drive(isMoveBackAvailableObserver).disposed(by: self.disposeBag)
//                }
//                
//                context("and onboarding is not passed") {
//                    it("move back shouldn't be avaliable", closure: {
//                        userStorage.isOnboardingPassed.accept(false)
//                        try? expect(sut.isMoveBackAvailable.toBlocking().first()).to(beTruthy())
//                    })
//                }
//                context("and onboarding is passed") {
//                    it("move back should be avaliable", closure: {
//                        userStorage.isOnboardingPassed.accept(true)
//                        try? expect(sut.isMoveBackAvailable.toBlocking().first()).to(beFalsy())
//                    })
//                }
//            })
//        }
//    }
//}
