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
            let appEnvironment = AppEnvironmentMock(apiURL: .new(), appVersion: .new(), isDebug: .new(), appStoreURL: .new(), donateURL: .new(), skinsApiURL: .new(), skinsCoverImageApiURL: .new(), flurryID: .new())
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
            
            func item(atSectionIndex sectionIndex: Int, itemIndex: Int) -> SectionItemViewModelType? {
                return (try? sut.sections.toBlocking().first()?[safe: sectionIndex]?.items.toBlocking().first()?[safe: itemIndex]) ?? nil
            }
        }
    }
}
