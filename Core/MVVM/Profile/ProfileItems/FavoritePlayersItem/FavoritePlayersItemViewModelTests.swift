//
//  FavoritePlayersItemViewModelTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class FavoritePlayersItemViewModelTests: BaseTestCase {
    override func spec() {
        describe("FavoritePlayersItemViewModel") {
            let playersStorage = PlayersStorageMock()
            playersStorage.getFavoritePreviewReturnValue = .just([])
        
            describe("when ask count of players") {
                context("and retrieving data") {
                    it("should return count of players") {
                        let player = PlayerPreview.new(
                            nickname: .new(),
                            profileImageSize: ImageSize.new(height: .new(), weight: .new()),
                            avatarURL: .new(),
                            id: .new()
                        )
                        let players = [player, player]
                        playersStorage.getFavoritePreviewReturnValue = .just(players)
                        
                        let sut = FavoritePlayersItemViewModelImpl(playersStorage: playersStorage)
                        
                        try? expect(sut.countOfPlayers.toBlocking().first()).to(equal(Strings.Favoriteplayers.playersCount(players.count)))
                    }
                }
                
                context("and retrieving empty data") {
                    it("should return no content") {
                        playersStorage.getFavoritePreviewReturnValue = .just([])
                        
                        let sut = FavoritePlayersItemViewModelImpl(playersStorage: playersStorage)
                        
                        try? expect(sut.countOfPlayers.toBlocking().first()).to(equal(Strings.Favoriteplayers.NoContent.title))
                    }
                }
            }
        }
    }
}
