//
//  PlayerBannerItemViewModelTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 22.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class PlayerBannerItemViewModelTests: BaseTestCase {
    override func spec() {
        describe("PlayerBannerItemViewModel") {
            describe("when ask cover image URL") {
                it("should have valid cover image URL") {
                    let playerBanner = PlayerBanner.new(coverImageURL: URL.new(), id: Int.random(), updatedDate: Date.random())
                    
                    let sut = PlayerBannerItemViewModelImpl(playerBanner: playerBanner)
                    
                    try? expect(sut.coverImageURL.toBlocking().first().flatMap{ $0 }).to(equal(playerBanner.coverImageURL))
                }
            }
            
            describe("when ask title") {
                it("should have valid title") {
                    func test(withUpdatedDate updatedDate: Date, expectedTitle: String) {
                        let playerBanner = PlayerBanner.new(coverImageURL: URL.new(), id: Int.random(), updatedDate: updatedDate)
                        let sut = PlayerBannerItemViewModelImpl(playerBanner: playerBanner)
                        try? expect(sut.title.toBlocking().first()).to(equal(expectedTitle))
                    }
                    
                    let today = Date()
                    let yesterday = Calendar.current.date(byAdding: .day, value: -2, to: today) ?? today
                    let monthAgo = Calendar.current.date(byAdding: .day, value: 31, to: today) ?? today
                    
                    test(withUpdatedDate: today, expectedTitle: Strings.PlayerBanner.updatedToday)
                    test(withUpdatedDate: yesterday, expectedTitle: Strings.PlayerBanner.updatedYesterday)
                    test(withUpdatedDate: monthAgo, expectedTitle: Strings.PlayerBanner.updatedLongTime)
                }
            }
        }
    }
}
