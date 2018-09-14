//
//  PlayersViewModelTests.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class PlayersViewModelTests: BaseTestCase {
    override func spec() {
        describe("PlayersViewModel") {
            let playersService = PlayersServiceMock()
            var sut: PlayersViewModel!
            
            beforeEach {
                sut = PlayersViewModelImpl(playersService: playersService)
            }
            
            describe("when calling refresh did trigger") {
                context("and retrieving data") {
                    let player1 = PlayerPreview.new(
                        nickname: String.random(),
                        profileImageSize: ImageSize.new(height: 0, weight: 0),
                        avatarURL: nil,
                        id: Int.random()
                    )
                    let player2 = PlayerPreview.new(
                        nickname: String.random(),
                        profileImageSize: ImageSize.new(height: 0, weight: 0),
                        avatarURL: URL.new(),
                        id: Int.random()
                    )
                    let content = [player1, player2]
                    
                    beforeEach {
                        playersService.getPreviewPageReturnValue = .just(Result(value: Page.new(content: content, index: 0, totalPages: 0)))
                    }
                    
                    it("should return players") {
                        sut.playersPaginator.refreshTrigger.onNext(())
                        
                        try? expect(sut.playersPaginator.elements.toBlocking().first()?.count).to(equal(content.count))
                        try? expect(sut.playersPaginator.elements.toBlocking().first()?.first?.nickname.toBlocking().first()).to(equal(player1.nickname))
                        try? expect(sut.playersPaginator.elements.toBlocking().first()?.first?.avatarURL.filterNil().toBlocking().first()).to(beNil())
                        try? expect(sut.playersPaginator.elements.toBlocking().first()?.last?.nickname.toBlocking().first()).to(equal(player2.nickname))
                        try? expect(sut.playersPaginator.elements.toBlocking().first()?.last?.avatarURL.filterNil().toBlocking().first()).to(equal(player2.avatarURL))
                    }
                    
                    describe("when calling player did trigger") {
                        it("should route to valid player") {
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
                        playersService.getPreviewPageReturnValue = .just(Result(error: .unknown))
                    }
                    
                    it("should show error message") {
                        let observer = self.scheduler.createObserver(MessageViewModel.self)
                        sut.messageViewModel.drive(observer).disposed(by: self.disposeBag)
                        
                        sut.playersPaginator.refreshTrigger.onNext(())
                        
                        let messageVM = try? sut.messageViewModel.toBlocking().first()
                        try? expect(messageVM??.title.toBlocking(timeout: 1).first()).to(equal(Strings.Errors.error))
                    }
                }
            }
            
            describe("when calling profile did trigger") {
                it("should route to profile") {
                    let observer = self.scheduler.createObserver(Void.self)
                    sut.shouldRouteProfile.drive(observer).disposed(by: self.disposeBag)
                    
                    sut.profileTrigger.onNext(())
                    
                    expect(observer.events.count).to(equal(1))
                }
            }
        }
    }
}
