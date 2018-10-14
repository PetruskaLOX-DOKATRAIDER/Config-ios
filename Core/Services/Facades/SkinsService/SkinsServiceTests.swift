//
//  SkinsServiceTests.swift
//  Core
//
//  Created by Петрічук Олег Аркадійовіч on 22.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class SkinsServiceTests: BaseTestCase {
    override func spec() {
        describe("SkinsService") {
            let skin1 = Skin(name: String.random(), gunName: String.random(), prise: Int.random(), coverImageURL: URL.new())
            let skin2 = Skin(name: String.random(), gunName: String.random(), prise: Int.random(), coverImageURL: URL.new())
            var skinsAPIService: SkinsAPIServiceMock!
            var sut: SkinsService!
            
            beforeEach {
                skinsAPIService = SkinsAPIServiceMock()
                sut = SkinsServiceImpl(skinsAPIService: skinsAPIService)
            }
            
            describe("when subscribe for new skins") {
                context("and received new skin") {
                    it("should return this skin") {
                        let source = BehaviorRelay.init(value: Result<Skin, SkinsAPIServiceError>(error: .unknown))
                        skinsAPIService.subscribeForNewSkinsReturnValue = source.asDriver()
                        let receivedSkins = sut.subscribeForNewSkins().success().map{ [$0] }.scan([], accumulator: { $0 + $1 })
            
                        source.accept(Result(value: skin1))
                        try? expect(receivedSkins.toBlocking().first()?.count).toEventually(equal(1), timeout: 1)
                        try? expect(receivedSkins.toBlocking().first()?.first?.name).to(equal(skin1.name))
                        
                        source.accept(Result(value: skin2))
                        try? expect(receivedSkins.toBlocking().first()?.count).toEventually(equal(1), timeout: 1)
                        try? expect(receivedSkins.toBlocking().first()?.first?.name).toEventually(equal(skin2.name), timeout: 1)
                    }
                }
                context("and received error") {
                    it("should return this error") {
                        skinsAPIService.subscribeForNewSkinsReturnValue = .just(Result(error: .unknown))
                        try? expect(sut.subscribeForNewSkins().failure().toBlocking().first()).to(equal(SkinsServiceError.unknown))
                    }
                }
            }
        }
    }
}
