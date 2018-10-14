//
//  TeamsServiceTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 22.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class TeamsServiceTests: BaseTestCase {
    override func spec() {
        describe("TeamsService") {
            let player = PlayerPreview.new(nickname: String.random(), profileImageSize: ImageSize.new(height: Double.new(), weight: Double.new()), avatarURL: URL.new(), id: Int.random())
            let team1 = Team.new(name: String.random(), logoURL: URL.new(), id: Int.random(), players: [player])
            let team2 = Team.new(name: String.random(), logoURL: URL.new(), id: Int.random(), players: [])
            let reachabilityService = ReachabilityServiceMock(connection: .cellular)
            var teamsStorage: TeamsStorageMock!
            var teamsAPIService: TeamsAPIServiceMock!
            var sut: TeamsService!
            
            beforeEach {
                teamsStorage = TeamsStorageMock()
                teamsStorage.updateWithNewReturnValue = .just(())
                teamsAPIService = TeamsAPIServiceMock()
                sut = TeamsServiceImpl(reachabilityService: reachabilityService, teamsAPIService: teamsAPIService, teamsStorage: teamsStorage)
            }
            
            describe("when ask teams") {
                context("and there is no internet connection") {
                    it("should return teams from the storage") {
                        reachabilityService.connection = .none
                        teamsStorage.getReturnValue = .just([team1, team2])
                        
                        try? expect(sut.get(page: 1).success().toBlocking().first()?.content.count).to(equal(2))
                        try? expect(sut.get(page: 1).success().toBlocking().first()?.content.first?.id).to(equal(team1.id))
                        try? expect(sut.get(page: 1).success().toBlocking().first()?.content.last?.id).to(equal(team2.id))
                        expect(teamsAPIService.getPageCalled).to(beFalsy())
                    }
                }
                
                context("and there is internet connection") {
                    context("and API returned data") {
                        it("should return received data") {
                            reachabilityService.connection = .wifi
                            let page = Page.new(content: [team1, team2], index: Int.random(), totalPages: Int.random())
                            teamsAPIService.getPageReturnValue = .just(Result(value: page))
                            
                            try? expect(sut.get(page: 1).success().toBlocking().first()?.content.count).to(equal(page.content.count))
                            try? expect(sut.get(page: 1).success().toBlocking().first()?.content.first?.id).to(equal(team1.id))
                            try? expect(sut.get(page: 1).success().toBlocking().first()?.content.last?.id).to(equal(team2.id))
                            expect(teamsStorage.getCalled).to(beFalsy())
                        }
                        it("should ask storage to update data") {
                            reachabilityService.connection = .wifi
                            let page = Page.new(content: [team1, team2], index: Int.random(), totalPages: Int.random())
                            teamsAPIService.getPageReturnValue = .just(Result(value: page))
                            
                            _ = try? sut.get(page: 1).toBlocking().first()
                            
                            expect(teamsStorage.updateWithNewReceived?.count).to(equal(page.content.count))
                            expect(teamsStorage.updateWithNewReceived?.first?.id).to(equal(team1.id))
                            expect(teamsStorage.updateWithNewReceived?.last?.id).to(equal(team2.id))
                        }
                    }
                    
                    context("and API returned error") {
                        it("should return error") {
                            reachabilityService.connection = .wifi
                            teamsAPIService.getPageReturnValue = .just(.init(error: .init(key: "", value: "")))
                            
                            try? expect(sut.get(page: 1).failure().toBlocking().first()).to(equal(TeamsServiceError.serverError("")))
                        }
                    }
                }
            }
        }
    }
}
