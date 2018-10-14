//
//  SkinsViewModelTests.swift
//  Config
//
//  Created by Oleg Petrychuk on 23.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class SkinsViewModelTests: BaseTestCase {
    override func spec() {
        describe("SkinsViewModel") {
            var skinsService: SkinsServiceMock!
            var sut: SkinsViewModel!

            let containsFullName = "abcd"
            let containsSubName = "aB"
            let notContainsFullName = "efj"
        
            let skin1 = Skin(
                name: containsFullName,
                gunName: String.random(),
                prise: Int.random(),
                coverImageURL: nil
            )
            let skin2 = Skin(
                name: notContainsFullName,
                gunName: String.random(),
                prise: Int.random(),
                coverImageURL: nil
            )
            
            beforeEach {
                skinsService = SkinsServiceMock()
                sut = SkinsViewModelImpl(skinsService: skinsService)
            }
            
            describe("when refresh did trigger") {
                context("and received new skins") {
                    it("should add new received skins and reverse them and sort by date") {
                        let newSkinsReturnValue: BehaviorRelay<Result<Skin, SkinsServiceError>> = BehaviorRelay(value: Result(value: skin1))
                        let observer = self.scheduler.createObserver([SkinItemViewModel].self)
                        sut.skins.drive(observer).disposed(by: self.disposeBag)
                        skinsService.subscribeForNewSkinsReturnValue = newSkinsReturnValue.asDriver()
                        sut.refreshTrigger.onNext(())
                        
                        try? expect(sut.skins.toBlocking().first()?.count).to(equal(1))
                        try? expect(sut.skins.toBlocking().first()?.first?.title.toBlocking().first()).to(equal(skin1.name))
                        
                        newSkinsReturnValue.accept(Result(value: skin2))
                        
                        try? expect(sut.skins.toBlocking().first()?.count).to(equal(2))
                        try? expect(sut.skins.toBlocking().first()?.first?.title.toBlocking().first()).to(equal(skin2.name))
                        try? expect(sut.skins.toBlocking().first()?.last?.title.toBlocking().first()).to(equal(skin1.name))
                     
                        newSkinsReturnValue.accept(Result(error: .unknown))
                        
                        try? expect(sut.skins.toBlocking().first()?.count).to(equal(2))
                    }
                }
            }
            
            describe("when searching") {
                context("with empty text") {
                    it("should show all skins") {
                        let newSkinsReturnValue: BehaviorRelay<Result<Skin, SkinsServiceError>> = BehaviorRelay(value: Result(value: skin1))
                        let observer = self.scheduler.createObserver([SkinItemViewModel].self)
                        sut.skins.drive(observer).disposed(by: self.disposeBag)
                        skinsService.subscribeForNewSkinsReturnValue = newSkinsReturnValue.asDriver()
                        sut.refreshTrigger.onNext(())
                        newSkinsReturnValue.accept(Result(value: skin2))

                        sut.searchTrigger.onNext("")
                        
                        try? expect(sut.skins.toBlocking().first()?.count).to(equal(2))
                    }
                }
                
                context("with contained name") {
                    it("should show contained name skin after timeout") {
                        let newSkinsReturnValue: BehaviorRelay<Result<Skin, SkinsServiceError>> = BehaviorRelay(value: Result(value: skin1))
                        let observer = self.scheduler.createObserver([SkinItemViewModel].self)
                        sut.skins.drive(observer).disposed(by: self.disposeBag)
                        skinsService.subscribeForNewSkinsReturnValue = newSkinsReturnValue.asDriver()
                        sut.refreshTrigger.onNext(())
                        newSkinsReturnValue.accept(Result(value: skin2))
                        
                        sut.searchTrigger.onNext(containsSubName)
                        
                        try? expect(sut.skins.toBlocking().first()?.map{ try $0.title.toBlocking().first() }.compactMap{ $0 }).toEventually(contain([skin1.name]), timeout: 3)
                    }
                }
            }
            
            describe("when refresh did trigger") {
                context("and received error") {
                    it("should show error message") {
                        let observer = self.scheduler.createObserver(MessageViewModel.self)
                        sut.messageViewModel.drive(observer).disposed(by: self.disposeBag)
                        skinsService.subscribeForNewSkinsReturnValue = .just(Result(error: .unknown))
                        
                        sut.refreshTrigger.onNext(())
                        
                        try? expect(sut.messageViewModel.toBlocking().first()?.description.toBlocking().first()).to(equal(Strings.Skins.disconect))
                    }
                }
            }
            
            describe("when ask working status") {
                context("on start") {
                    it("should working") {
                        try? expect(sut.isWorking.toBlocking().first()).to(beFalse())
                    }
                }
                
                context("when received data") {
                    it("shouldn't working") {
                        skinsService.subscribeForNewSkinsReturnValue = .just(Result(error: .unknown))
    
                        sut.refreshTrigger.onNext(())
    
                        try? expect(sut.isWorking.toBlocking().first()).to(beFalse())
                    }
                }
                
                context("when received error") {
                    it("shouldn't working") {
                        skinsService.subscribeForNewSkinsReturnValue = .just(Result(value: skin1))
                        
                        sut.refreshTrigger.onNext(())
                        
                        try? expect(sut.isWorking.toBlocking().first()).to(beFalse())
                    }
                }
            }
            
            describe("when calling close did trigger") {
                it("should notify about close") {
                    let observer = self.scheduler.createObserver(Void.self)
                    sut.shouldClose.drive(observer).disposed(by: self.disposeBag)
                    
                    sut.closeTrigger.onNext(())
                    
                    expect(observer.events.count).to(equal(1))
                }
            }
        }
    }
}
