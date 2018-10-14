//
//  BannerServiceTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 22.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class BannerServiceTests: BaseTestCase {
    override func spec() {
        describe("BannerService") {
            let player1 = PlayerBanner.new(coverImageURL: URL.new(), id: Int.random(), updatedDate: Date.random())
            let player2 = PlayerBanner.new(coverImageURL: URL.new(), id: Int.random(), updatedDate: Date.random())
            var bannerAPIService: BannerAPIServiceMock!
            var sut: BannerService!
            
            beforeEach {
                bannerAPIService = BannerAPIServiceMock()
                sut = BannerServiceImpl(bannerAPIService: bannerAPIService)
            }
            
            describe("when ask banners for players") {
                context("and received data") {
                    it("should return this data") {
                        let page = Page.new(content: [player1, player2], index: Int.random(), totalPages: Int.random())
                        bannerAPIService.getPlayersPageReturnValue = .just(Result(value: page))
                        
                        try? expect(sut.getForPlayers(page: 1).success().toBlocking().first()?.content.count).to(equal(2))
                        try? expect(sut.getForPlayers(page: 1).success().toBlocking().first()?.content.first?.id).to(equal(player1.id))
                        try? expect(sut.getForPlayers(page: 1).success().toBlocking().first()?.content.last?.id).to(equal(player2.id))
                    }
                }
                context("and received error") {
                    it("should return this error") {
                        bannerAPIService.getPlayersPageReturnValue = .just(.init(error: .init(key: "", value: "")))
                        
                        try? expect(sut.getForPlayers(page: 1).failure().toBlocking().first()).to(equal(BannerServiceError.serverError("")))
                    }
                }
            }
        }
    }
}
