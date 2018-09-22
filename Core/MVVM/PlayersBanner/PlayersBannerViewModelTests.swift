//
//  PlayersBannerViewModelTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 16.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class PlayersBannerViewModelTests: BaseTestCase {
    override func spec() {
        describe("PlayersBannerViewModel") {
            let bannerService = BannerServiceMock()
            var sut: PlayersBannerViewModel!
            
            beforeEach {
                sut = PlayersBannerViewModelImpl(bannerService: bannerService)
            }
            
            describe("when calling refresh did trigger") {
                context("and retrieving data") {
                    let player1 = PlayerBanner.new(coverImageURL: URL.new(), id: Int.random(), updatedDate: Date.random())
                    let player2 = PlayerBanner.new(coverImageURL: URL.new(), id: Int.random(), updatedDate: Date.random())
                    let content = [player1, player2]
                    
                    beforeEach {
                        bannerService.getForPlayersPageReturnValue = .just(Result(value: Page.new(content: content, index: 0, totalPages: 0)))
                    }
                    
                    it("should return teams") {
                        sut.playersPaginator.refreshTrigger.onNext(())
                        
                        try? expect(sut.playersPaginator.elements.toBlocking().first()?.count).to(equal(content.count))
                        try? expect(sut.playersPaginator.elements.toBlocking().first()?.first?.coverImageURL.toBlocking().first().flatMap{ $0 }).to(equal(player1.coverImageURL))
                        try? expect(sut.playersPaginator.elements.toBlocking().first()?.last?.coverImageURL.toBlocking().first().flatMap{ $0 }).to(equal(player2.coverImageURL))
                    }
                    
                    describe("when calling player did trigger") {
                        it("should route description") {
                            let observer = self.scheduler.createObserver(Int.self)
                            sut.shouldRouteDescription.drive(observer).disposed(by: self.disposeBag)
                            sut.playersPaginator.refreshTrigger.onNext(())
                            let playerItemVM = try? sut.playersPaginator.elements.toBlocking().first()?.first
                            
                            playerItemVM??.selectionTrigger.onNext(())
                            
                            try? expect(sut.shouldRouteDescription.toBlocking().first()).to(equal(player1.id))
                        }
                    }
                }
                
                context("and retrieving error") {
                    beforeEach {
                        bannerService.getForPlayersPageReturnValue = .just(Result(error: .unknown))
                    }
                    
                    it("should show error message") {
                        let observer = self.scheduler.createObserver(String.self)
                        sut.errorMessage.drive(observer).disposed(by: self.disposeBag)
                        
                        sut.playersPaginator.refreshTrigger.onNext(())
                        
                        try? expect(sut.errorMessage.toBlocking().first()).to(equal(Strings.Errors.generalMessage))
                    }
                }
            }
            
            context("when calling page did trigger") {
                it("should have valid current page") {
                    let observer = self.scheduler.createObserver(Int.self)
                    sut.currentPage.drive(observer).disposed(by: self.disposeBag)
                    
                    try? expect(sut.currentPage.toBlocking().first()).to(equal(0))
                    
                    let nextPage = Int.random()
                    sut.pageTrigger.onNext(nextPage)
                    
                    try? expect(sut.currentPage.toBlocking().first()).to(equal(nextPage))
                }
            }
        }
    }
}
