//
//  ProfileViewModelTests.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class ProfileViewModelTests: BaseTestCase {
    override func spec() {
        describe("ProfileViewModel") {
            let appEnvironment = AppEnvironmentMock(
                apiURL: .new(),
                appVersion: .new(),
                isDebug: .new(),
                appStoreURL: .new(),
                donateURL: .new(),
                skinsApiURL: .new(),
                skinsCoverImageApiURL: .new(),
                flurryID: .new()
            )
            let playersStorage = PlayersStorageMock()
            playersStorage.getFavoritePreviewReturnValue = .just([])
            let imageLoaderService = ImageLoaderServiceImpl()
            let userStorage = UserStorageMock(isOnboardingPassed: BehaviorRelay(value: false), email: BehaviorRelay(value: nil))
            var sut: ProfileViewModel!
            
            beforeEach {
                sut = ProfileViewModelImpl(appEnvironment: appEnvironment, playersStorage: playersStorage, imageLoaderService: imageLoaderService, userStorage: userStorage)
            }
            
            describe("when ask sections") {
                it("should return valid sections") {
                    try? expect(sut.sections.toBlocking().first()?.count).to(equal(3))
                    try? expect(sut.sections.toBlocking().first()?[safe: 0]?.items.toBlocking().first()?.count).to(equal(2))
                    try? expect(sut.sections.toBlocking().first()?[safe: 1]?.items.toBlocking().first()?.count).to(equal(6))
                    try? expect(sut.sections.toBlocking().first()?[safe: 2]?.items.toBlocking().first()?.count).to(equal(1))
    
                    expect(item(atSectionIndex: 0, itemIndex: 0)).to(beAKindOf(FavoritePlayersItemViewModel.self))
                    expect(item(atSectionIndex: 0, itemIndex: 1)).to(beAKindOf(SectionItemViewModel.self))
                    expect(item(atSectionIndex: 1, itemIndex: 0)).to(beAKindOf(SectionItemViewModel.self))
                    expect(item(atSectionIndex: 1, itemIndex: 1)).to(beAKindOf(SectionItemViewModel.self))
                    expect(item(atSectionIndex: 1, itemIndex: 2)).to(beAKindOf(SectionItemViewModel.self))
                    expect(item(atSectionIndex: 1, itemIndex: 3)).to(beAKindOf(SectionItemViewModel.self))
                    expect(item(atSectionIndex: 1, itemIndex: 4)).to(beAKindOf(ProfileEmailItemViewModel.self))
                    expect(item(atSectionIndex: 1, itemIndex: 5)).to(beAKindOf(SectionItemViewModel.self))
                    expect(item(atSectionIndex: 2, itemIndex: 0)).to(beAKindOf(StorageSetupViewModel.self))
                }
            }
            
            describe("when Favorite Players selection did trigger") {
                it("should route to Favorite Players") {
                    let observer = self.scheduler.createObserver(Void.self)
                    sut.shouldRouteFavoritePlayers.drive(observer).disposed(by: self.disposeBag)
                    
                    let itemVM = item(atSectionIndex: 0, itemIndex: 0) as? FavoritePlayersItemViewModel
                    itemVM?.selectionTrigger.onNext(())
                    
                    expect(observer.events.count).to(equal(1))
                }
            }
            
            describe("when Skins selection did trigger") {
                it("should route to Skins") {
                    let observer = self.scheduler.createObserver(Void.self)
                    sut.shouldRouteSkins.drive(observer).disposed(by: self.disposeBag)
                    
                    let itemVM = item(atSectionIndex: 0, itemIndex: 1) as? SectionItemViewModel
                    itemVM?.selectionTrigger.onNext(())
                    
                    expect(observer.events.count).to(equal(1))
                }
            }
            
            describe("when Feedback selection did trigger") {
                it("should route to Feedback") {
                    let observer = self.scheduler.createObserver(Void.self)
                    sut.shouldSendFeedback.drive(observer).disposed(by: self.disposeBag)
                    
                    let itemVM = item(atSectionIndex: 1, itemIndex: 0) as? SectionItemViewModel
                    itemVM?.selectionTrigger.onNext(())
                    
                    expect(observer.events.count).to(equal(1))
                }
            }
            
            describe("when Donate selection did trigger") {
                it("should open valid URL") {
                    let observer = self.scheduler.createObserver(URL.self)
                    sut.shouldOpenURL.drive(observer).disposed(by: self.disposeBag)
                    
                    let itemVM = item(atSectionIndex: 1, itemIndex: 1) as? SectionItemViewModel
                    itemVM?.selectionTrigger.onNext(())
                    
                    try? expect(sut.shouldOpenURL.toBlocking().first()).to(equal(appEnvironment.donateURL))
                }
            }
            
            describe("when Rate App selection did trigger") {
                it("should open valid URL") {
                    let observer = self.scheduler.createObserver(URL.self)
                    sut.shouldOpenURL.drive(observer).disposed(by: self.disposeBag)
                    
                    let itemVM = item(atSectionIndex: 1, itemIndex: 2) as? SectionItemViewModel
                    itemVM?.selectionTrigger.onNext(())
                    
                    try? expect(sut.shouldOpenURL.toBlocking().first()).to(equal(appEnvironment.appStoreURL))
                }
            }
            
            describe("when Share App selection did trigger") {
                it("should share valid URL") {
                    let observer = self.scheduler.createObserver(ShareItem.self)
                    sut.shouldShare.drive(observer).disposed(by: self.disposeBag)
                    
                    let itemVM = item(atSectionIndex: 1, itemIndex: 3) as? SectionItemViewModel
                    itemVM?.selectionTrigger.onNext(())
                    
                    try? expect(sut.shouldShare.toBlocking().first()?.url).to(equal(appEnvironment.appStoreURL))
                }
            }
            
            describe("when Tutorial selection did trigger") {
                it("should route to Tutorial") {
                    let observer = self.scheduler.createObserver(Void.self)
                    sut.shouldRouteTutorial.drive(observer).disposed(by: self.disposeBag)
                    
                    let itemVM = item(atSectionIndex: 1, itemIndex: 5) as? SectionItemViewModel
                    itemVM?.selectionTrigger.onNext(())
                    
                    expect(observer.events.count).to(equal(1))
                }
            }
            
            describe("when Tutorial selection did trigger") {
                it("should route to Tutorial") {
                    let observer = self.scheduler.createObserver(MessageViewModel.self)
                    sut.messageViewModel.drive(observer).disposed(by: self.disposeBag)
                    
                    let itemVM = item(atSectionIndex: 2, itemIndex: 0) as? StorageSetupViewModel
                    itemVM?.clearTrigger.onNext(())
                    
                    try? expect(sut.messageViewModel.toBlocking().first()?.description.toBlocking().first()).to(equal(Strings.Storage.cleared))
                }
            }
            
            func item(atSectionIndex sectionIndex: Int, itemIndex: Int) -> SectionItemViewModelType? {
                return (try? sut.sections.toBlocking().first()?[safe: sectionIndex]?.items.toBlocking().first()?[safe: itemIndex]) ?? nil
            }
        }
    }
}
