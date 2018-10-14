//
//  PlayersServiceTests.swift
//  Core
//
//  Created by Петрічук Олег Аркадійовіч on 22.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class PlayersServiceTests: BaseTestCase {
    override func spec() {
        describe("PlayersService") {
            let playerDescription = PlayerDescription.new(id: Int.random(), nickname: String.random(), name: String.random(), surname: String.random(), avatarURL: URL.new(), country: String.random(), teamName: String.random(), teamLogoURL: URL.new(), flagURL: URL.new(), moreInfoURL: URL.new(), mouse: String.random(), mousepad: String.random(), monitor: String.random(), keyboard: String.random(), headSet: String.random(), effectiveDPI: String.random(), gameResolution: String.random(), windowsSensitivity: String.random(), pollingRate: String.random(), configURL: URL.new())
            let player1 = PlayerPreview.new(nickname: String.random(), profileImageSize: ImageSize.new(height: Double.new(), weight: Double.new()), avatarURL: URL.new(), id: Int.random())
            let player2 = PlayerPreview.new(nickname: String.random(), profileImageSize: ImageSize.new(height: Double.new(), weight: Double.new()), avatarURL: URL.new(), id: Int.random())
            let reachabilityService = ReachabilityServiceMock(connection: .cellular)
            var playersStorage: PlayersStorageMock!
            var playersAPIService: PlayersAPIServiceMock!
            var sut: PlayersService!
            
            beforeEach {
                playersStorage = PlayersStorageMock()
                playersStorage.updatePreviewWithNewReturnValue = .just(())
                playersStorage.updateDescriptionWithNewReturnValue = .just(())
                playersAPIService = PlayersAPIServiceMock()
                sut = PlayersServiceImpl(reachabilityService: reachabilityService, playersAPIService: playersAPIService, playersStorage: playersStorage)
            }
            
            describe("when ask players preview") {
                context("and there is no internet connection") {
                    it("should return players preview from the storage") {
                        reachabilityService.connection = .none
                        playersStorage.getPreviewReturnValue = .just([player1, player2])
                        
                        try? expect(sut.getPreview(page: 1).success().toBlocking().first()?.content.count).to(equal(2))
                        try? expect(sut.getPreview(page: 1).success().toBlocking().first()?.content.first?.id).to(equal(player1.id))
                        try? expect(sut.getPreview(page: 1).success().toBlocking().first()?.content.last?.id).to(equal(player2.id))
                        expect(playersAPIService.getPreviewPageCalled).to(beFalsy())
                    }
                }
                
                context("and there is internet connection") {
                    context("and API returned data") {
                        it("should return received data") {
                            reachabilityService.connection = .wifi
                            let page = Page.new(content: [player1, player2], index: Int.random(), totalPages: Int.random())
                            playersAPIService.getPreviewPageReturnValue = .just(Result(value: page))
                            
                            try? expect(sut.getPreview(page: 1).success().toBlocking().first()?.content.count).to(equal(page.content.count))
                            try? expect(sut.getPreview(page: 1).success().toBlocking().first()?.content.first?.id).to(equal(player1.id))
                            try? expect(sut.getPreview(page: 1).success().toBlocking().first()?.content.last?.id).to(equal(player2.id))
                            expect(playersStorage.getPreviewCalled).to(beFalsy())
                        }
                        it("should ask storage to update data") {
                            reachabilityService.connection = .wifi
                            let page = Page.new(content: [player1, player2], index: Int.random(), totalPages: Int.random())
                            playersAPIService.getPreviewPageReturnValue = .just(Result(value: page))
                            
                            _ = try? sut.getPreview(page: 1).toBlocking().first()
                            
                            expect(playersStorage.updatePreviewWithNewReceived?.count).to(equal(page.content.count))
                            expect(playersStorage.updatePreviewWithNewReceived?.first?.id).to(equal(player1.id))
                            expect(playersStorage.updatePreviewWithNewReceived?.last?.id).to(equal(player2.id))
                        }
                    }
                    
                    context("and API returned error") {
                        it("should return error") {
                            reachabilityService.connection = .wifi
                            playersAPIService.getPreviewPageReturnValue = .just(.init(error: .init(key: "", value: "")))
                            
                            try? expect(sut.getPreview(page: 1).failure().toBlocking().first()).to(equal(PlayersServiceError.serverError("")))
                        }
                    }
                }
            }
            
            describe("when ask player description") {
                context("and there is no internet connection") {
                    it("should return news description from the storage") {
                        reachabilityService.connection = .none
                        playersStorage.getDescriptionPlayerReturnValue = .just(playerDescription)
                        
                        try? expect(sut.getDescription(player: 1).success().toBlocking().first()?.id).to(equal(playerDescription.id))
                        try? expect(sut.getDescription(player: 1).success().toBlocking().first()?.name).to(equal(playerDescription.name))
                        expect(playersAPIService.getDescriptionPlayerCalled).to(beFalsy())
                    }
                }
                
                context("and there is internet connection") {
                    context("and API returned data") {
                        it("should return received data") {
                            reachabilityService.connection = .wifi
                            playersAPIService.getDescriptionPlayerReturnValue = .just(Result(value: playerDescription))
                            
                            try? expect(sut.getDescription(player: 1).success().toBlocking().first()?.id).to(equal(playerDescription.id))
                            try? expect(sut.getDescription(player: 1).success().toBlocking().first()?.name).to(equal(playerDescription.name))
                            expect(playersStorage.getDescriptionPlayerCalled).to(beFalsy())
                        }
                        it("should ask storage to update data") {
                            reachabilityService.connection = .wifi
                            playersAPIService.getDescriptionPlayerReturnValue = .just(Result(value: playerDescription))
                            
                            _ = try? sut.getDescription(player: 1).success().toBlocking().first()
                            
                            expect(playersStorage.updateDescriptionWithNewReceived?.id).to(equal(playerDescription.id))
                            expect(playersStorage.updateDescriptionWithNewReceived?.name).to(equal(playerDescription.name))
                        }
                    }
                    
                    context("and API returned error") {
                        it("should return error") {
                            reachabilityService.connection = .wifi
                            playersAPIService.getDescriptionPlayerReturnValue = .just(.init(error: .init(key: "", value: "")))
                            
                            try? expect(sut.getDescription(player: 1).failure().toBlocking().first()).to(equal(PlayersServiceError.serverError("")))
                        }
                    }
                }
            }
            
            describe("when ask to add player to favorites") {
                context("and player is not in favorites") {
                    it("should ask players storage to add to favorites with valid player id") {
                        let playerId = Int.random()
                        playersStorage.isFavouritePlayerReturnValue = .just(false)
                        playersStorage.addFavouriteReturnValue = .just(())
                        
                        _ = sut.add(favourite: playerId)
                        
                        expect(playersStorage.addFavouriteReceived).to(equal(playerId))
                    }
                    
                    it("should return success") {
                        let observer = self.scheduler.createObserver(Void.self)
                        playersStorage.addFavouriteReturnValue = .just(())
                        playersStorage.isFavouritePlayerReturnValue = .just(false)
                        sut.add(favourite: Int.random()).success().drive(observer).disposed(by: self.disposeBag)
                        expect(observer.events.count).toNot(equal(0))
                    }
                }
                
                context("and player already in favorites") {
                    it("should return valid error") {
                        playersStorage.addFavouriteReturnValue = .just(())
                        playersStorage.isFavouritePlayerReturnValue = .just(true)
                        
                        try? expect(sut.add(favourite: Int.random()).failure().toBlocking().first()).to(equal(.playerIsFavorite))
                    }
                }
            }
            
            describe("when ask to remove player from favorites") {
                context("and player in favorites") {
                    it("should ask players storage to add to remove player with valid player id") {
                        let playerId = Int.random()
                        playersStorage.isFavouritePlayerReturnValue = .just(true)
                        playersStorage.removeFavouriteReturnValue = .just(())
                        
                        _ = sut.remove(favourite: playerId)
                        
                        expect(playersStorage.removeFavouriteReceived).to(equal(playerId))
                    }
                    
                    it("should return success") {
                        let observer = self.scheduler.createObserver(Void.self)
                        playersStorage.removeFavouriteReturnValue = .just(())
                        playersStorage.isFavouritePlayerReturnValue = .just(true)
                        sut.remove(favourite: Int.random()).success().drive(observer).disposed(by: self.disposeBag)
                        expect(observer.events.count).toNot(equal(0))
                    }
                }
                
                context("and player is not in favorites") {
                    it("should return valid error") {
                        playersStorage.isFavouritePlayerReturnValue = .just(false)
                        playersStorage.removeFavouriteReturnValue = .just(())
                        
                        try? expect(sut.remove(favourite: Int.random()).failure().toBlocking().first()).to(equal(.playerIsNotFavorite))
                    }
                }
            }
            
            describe("when ask is player favorite") {
                it("should ask storage with valid player id") {
                    let playerId = Int.random()
                    playersStorage.isFavouritePlayerReturnValue = .just(true)
                    _ = sut.isFavourite(player: playerId)
                    expect(playersStorage.isFavouritePlayerReceived).to(equal(playerId))
                }
                
                context("and storage return false") {
                    it("should return false") {
                        playersStorage.isFavouritePlayerReturnValue = .just(true)
                        
                        try? expect(sut.isFavourite(player: 3).success().toBlocking().first()).to(equal(true))
                    }
                }
                
                context("nd storage return true") {
                    it("should return true") {
                        playersStorage.isFavouritePlayerReturnValue = .just(false)
                        
                        try? expect(sut.isFavourite(player: 3).success().toBlocking().first()).to(equal(false))
                    }
                }
            }
        }
    }
}
