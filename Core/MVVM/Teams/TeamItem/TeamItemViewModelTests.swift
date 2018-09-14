//
//  TeamItemViewModelTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 12.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class TeamItemViewModelTests: BaseTestCase {
    override func spec() {
        describe("TeamItemViewModel") {
            describe("when ask proporties") {
                it("should return valid proporties") {
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
                    let team = Team.new(
                        name: String.random(),
                        logoURL: nil,
                        id: 0,
                        players: [player1, player2]
                    )
                    
                    let sut = TeamItemViewModelImpl(team: team)
                    
                    expect(sut.players.count).to(equal(team.players.count))
                    try? expect(sut.name.toBlocking().first()).to(equal(team.name))
                    try? expect(sut.logoURL.filterNil().toBlocking().first()).to(beNil())
                    try? expect(sut.players.first?.nickname.toBlocking().first()).to(equal(player1.nickname))
                    try? expect(sut.players.first?.avatarURL.filterNil().toBlocking().first()).to(beNil())
                    try? expect(sut.players.last?.nickname.toBlocking().first()).to(equal(player2.nickname))
                    try? expect(sut.players.last?.avatarURL.filterNil().toBlocking().first()).to(equal(player2.avatarURL))
                }
            }
        }
    }
}
