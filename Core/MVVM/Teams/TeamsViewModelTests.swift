//
//  TeamsViewModelTests.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class TeamsViewModelTests: BaseTestCase {
    override func spec() {
        describe("TeamsViewModel") {
            let teamsService = TeamsServiceMock()
            var sut: TeamsViewModel!
            
            beforeEach {
                sut = TeamsViewModelImpl(teamsService: teamsService, playersBannerViewModel: PlayersBannerViewModelImpl(bannerService: BannerServiceMock()))
            }
            
            describe("when refresh trigger") {
                context("and TeamsService successfully return teams") {
                    let player1 = PlayerPreview.new(
                        nickname: String.random(),
                        profileImageSize: ImageSize.new(height: 0, weight: 0),
                        avatarURL: URL.new(),
                        id: Int.random()
                    )
                    let player2 = PlayerPreview.new(
                        nickname: String.random(),
                        profileImageSize: ImageSize.new(height: 0, weight: 0),
                        avatarURL: nil,
                        id: Int.random()
                    )
                    let team1 = Team.new(
                        name: String.random(),
                        logoURL: nil,
                        id: Int.random(),
                        players: [player1]
                    )
                    let team2 = Team.new(
                        name: String.random(),
                        logoURL: URL.new(),
                        id: Int.random(),
                        players: [player1, player2]
                    )
                    let content = [team1, team2]
                    
                    beforeEach {
                        teamsService.getPageReturnValue = .just(Result(value: Page.new(content: content, index: 0, totalPages: 0)))
                    }
                    
                    it("should return valid items", closure: {
                        sut.teamsPaginator.refreshTrigger.onNext(())
                        try? expect(sut.teamsPaginator.elements.toBlocking().first()?.count).to(equal(content.count))
                        try? expect(sut.teamsPaginator.elements.toBlocking().first()?.first?.name.toBlocking().first()).to(equal(team1.name))
                        try? expect(sut.teamsPaginator.elements.toBlocking().first()?.first?.logoURL.filterNil().toBlocking().first()).to(beNil())
                        try? expect(sut.teamsPaginator.elements.toBlocking().first()?.first?.players.count).to(equal(team1.players.count))
                        try? expect(sut.teamsPaginator.elements.toBlocking().first()?.last?.name.toBlocking().first()).to(equal(team2.name))
                        try? expect(sut.teamsPaginator.elements.toBlocking().first()?.last?.logoURL.filterNil().toBlocking().first()).to(equal(team2.logoURL))
                        try? expect(sut.teamsPaginator.elements.toBlocking().first()?.last?.players.count).to(equal(team2.players.count))
                        let playerVM = try? sut.teamsPaginator.elements.toBlocking().first()?.first?.players.first
                        try? expect(playerVM??.nickname.toBlocking().first()).to(equal(player1.nickname))
                        try? expect(playerVM??.avatarURL.filterNil().toBlocking().first()).to(equal(player1.avatarURL))
                    })
                    
                    describe("when player item selection trigger") {
                        it("should route to player description", closure: {
                            let observer = self.scheduler.createObserver(Int.self)
                            sut.shouldRouteDescription.drive(observer).disposed(by: self.disposeBag)
                            sut.teamsPaginator.refreshTrigger.onNext(())
                            let playerItemVM = try? sut.teamsPaginator.elements.toBlocking().first()?.first?.players.first
                            playerItemVM??.selectionTrigger.onNext(())
                            try? expect(sut.shouldRouteDescription.toBlocking().first()).to(equal(player1.id))
                            
                        })
                    }
                }
                
                context("and PlayersService failed to return players") {
                    beforeEach {
                        teamsService.getPageReturnValue = .just(Result(error: .unknown))
                    }
                    
                    it("should show error message", closure: {
                        let observer = self.scheduler.createObserver(MessageViewModel.self)
                        sut.messageViewModel.drive(observer).disposed(by: self.disposeBag)
                        sut.teamsPaginator.refreshTrigger.onNext(())
                        let messageVM = try? sut.messageViewModel.toBlocking().first()
                        try? expect(messageVM??.title.toBlocking(timeout: 1).first()).to(equal(Strings.Errors.error))
                    })
                }
            }
            
            describe("when profile trigger") {
                it("should route to profile", closure: {
                    let observer = self.scheduler.createObserver(Void.self)
                    sut.shouldRouteProfile.drive(observer).disposed(by: self.disposeBag)
                    sut.profileTrigger.onNext(())
                    expect(observer.events.count).to(equal(1))
                })
            }
        }
    }
}
