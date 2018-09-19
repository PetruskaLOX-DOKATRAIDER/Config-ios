//
//  FavoritePlayersViewModelTests.swift
//  Config
//
//  Created by Oleg Petrychuk on 02.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class FavoritePlayersViewModelTests: BaseTestCase {
    override func spec() {
        describe("FavoritePlayersViewModel") {
            let playersService = PlayersServiceMock()
            var sut: FavoritePlayersViewModel!
            
            beforeEach {
                sut = FavoritePlayersViewModelImpl(playersService: playersService)
            }
            
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
            let players: [PlayerPreview] = [player1, player2]
            
            describe("when refresh did trigger") {
                describe("and ask players") {
                    it("should return received players") {
                        let observer = self.scheduler.createObserver([PlayerPreviewViewModel].self)
                        sut.players.drive(observer).disposed(by: self.disposeBag)
                        playersService.getFavoritePreviewReturnValue = .just(Result(value: players))

                        sut.refreshTrigger.onNext(())

                        try? expect(sut.players.toBlocking().first()?.count).to(equal(players.count))
                        try? expect(sut.players.toBlocking().first()?.first?.nickname.toBlocking().first()).to(equal(player1.nickname))
                        try? expect(sut.players.toBlocking().first()?.last?.nickname.toBlocking().first()).to(equal(player2.nickname))
                    }
                }
                
                describe("and calling player did trigger") {
                    it("should route to valid player") {
                        let playersObserver = self.scheduler.createObserver([PlayerPreviewViewModel].self)
                        sut.players.drive(playersObserver).disposed(by: self.disposeBag)
                        let observer = self.scheduler.createObserver(Int.self)
                        sut.shouldRouteDescription.drive(observer).disposed(by: self.disposeBag)
                        playersService.getFavoritePreviewReturnValue = .just(Result(value: players))
                        sut.refreshTrigger.onNext(())
                        
                        let playerItemVM = try? sut.players.toBlocking().first()?.first
                        playerItemVM??.selectionTrigger.onNext(())

                        try? expect(sut.shouldRouteDescription.toBlocking().first()).to(equal(player1.id))
                    }
                }
                
                describe("when ask is content exist") {
                    context("and received some data") {
                        it("content should exist") {
                            let observer = self.scheduler.createObserver(Bool.self)
                            sut.isContentExist.drive(observer).disposed(by: self.disposeBag)
                            playersService.getFavoritePreviewReturnValue = .just(Result(value: players))

                            sut.refreshTrigger.onNext(())

                            try? expect(sut.isContentExist.toBlocking().first()).to(beTruthy())
                        }
                    }

                    context("and received no data") {
                        it("content should not exist") {
                            let observer = self.scheduler.createObserver(Bool.self)
                            sut.isContentExist.drive(observer).disposed(by: self.disposeBag)
                            playersService.getFavoritePreviewReturnValue = .just(Result(value: []))

                            sut.refreshTrigger.onNext(())

                            try? expect(sut.isContentExist.toBlocking().first()).to(beFalsy())
                        }
                    }
                }
            }
            
            describe("when calling close did trigger") {
                it("should close") {
                    let observer = self.scheduler.createObserver(Void.self)
                    sut.shouldClose.drive(observer).disposed(by: self.disposeBag)
                    
                    sut.closeTrigger.onNext(())
                    
                    expect(observer.events.count).to(equal(1))
                }
            }
        }
    }
}
