//
//  PlayerInfoViewModelTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 19.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class PlayerInfoViewModelTests: BaseTestCase {
    override func spec() {
        describe("PlayerInfoViewModel") {
            let player = PlayerDescription.new(id: Int.random(), nickname: String.random(), name: String.random(), surname: String.random(), avatarURL: URL.new(), country: String.random(), teamName: String.random(), teamLogoURL: URL.new(), flagURL: URL.new(), moreInfoURL: URL.new(), mouse: String.random(), mousepad: String.random(), monitor: String.random(), keyboard: String.random(), headSet: String.random(), effectiveDPI: String.random(), gameResolution: String.random(), windowsSensitivity: String.random(), pollingRate: String.random(), configURL: URL.new())
            let playerSource: BehaviorRelay<PlayerDescription?> = BehaviorRelay(value: nil)
            var sut: PlayerInfoViewModel!
            
            beforeEach {
                sut = PlayerInfoViewModelImpl(player: playerSource.asDriver().filterNil())
            }
            
            describe("when ask properties") {
                it("should return valid properties") {
                    let fullNameObserver = self.scheduler.createObserver(String.self)
                    sut.fullName.drive(fullNameObserver).disposed(by: self.disposeBag)
                    let avatarObserver = self.scheduler.createObserver(URL?.self)
                    sut.avatarURL.drive(avatarObserver).disposed(by: self.disposeBag)
                    let personalInfoObserver = self.scheduler.createObserver([HighlightText].self)
                    sut.personalInfo.drive(personalInfoObserver).disposed(by: self.disposeBag)
                    let hardwareObserver = self.scheduler.createObserver([HighlightText].self)
                    sut.hardware.drive(hardwareObserver).disposed(by: self.disposeBag)
                    let settingsObserver = self.scheduler.createObserver([HighlightText].self)
                    sut.settings.drive(settingsObserver).disposed(by: self.disposeBag)
                    playerSource.accept(player)

                    try? expect(sut.fullName.toBlocking().first()).to(equal("\(player.name) \"\(player.nickname)\" \(player.surname)"))
                    try? expect(sut.avatarURL.filterNil().toBlocking().first()).to(equal(player.avatarURL))
                    
                    try? expect(sut.personalInfo.toBlocking().first()?.count).to(equal(4))
                    try? expect(sut.personalInfo.toBlocking().first()?[safe: 0]?.full).to(equal(Strings.PlayerDescription.realName("\(player.surname) \(player.name)")))
                    try? expect(sut.personalInfo.toBlocking().first()?[safe: 0]?.highlights).to(equal(["\(player.surname) \(player.name)"]))
                    
                    try? expect(sut.personalInfo.toBlocking().first()?[safe: 1]?.full).to(equal(Strings.PlayerDescription.nickname(player.nickname)))
                    try? expect(sut.personalInfo.toBlocking().first()?[safe: 1]?.highlights).to(equal([player.nickname]))
                    try? expect(sut.personalInfo.toBlocking().first()?[safe: 2]?.full).to(equal(Strings.PlayerDescription.fromCountry(player.country)))
                    try? expect(sut.personalInfo.toBlocking().first()?[safe: 2]?.highlights).to(equal([player.country]))
                    try? expect(sut.personalInfo.toBlocking().first()?[safe: 3]?.full).to(equal(Strings.PlayerDescription.team(player.teamName)))
                    try? expect(sut.personalInfo.toBlocking().first()?[safe: 3]?.highlights).to(equal([player.teamName]))
                    
                    try? expect(sut.hardware.toBlocking().first()?.count).to(equal(5))
                    try? expect(sut.hardware.toBlocking().first()?[safe: 0]?.full).to(equal(Strings.PlayerDescription.mouse(player.mouse)))
                    try? expect(sut.hardware.toBlocking().first()?[safe: 0]?.highlights).to(equal([player.mouse]))
                    try? expect(sut.hardware.toBlocking().first()?[safe: 1]?.full).to(equal(Strings.PlayerDescription.mousepad(player.mousepad)))
                    try? expect(sut.hardware.toBlocking().first()?[safe: 1]?.highlights).to(equal([player.mousepad]))
                    try? expect(sut.hardware.toBlocking().first()?[safe: 2]?.full).to(equal(Strings.PlayerDescription.monitor(player.monitor)))
                    try? expect(sut.hardware.toBlocking().first()?[safe: 2]?.highlights).to(equal([player.monitor]))
                    try? expect(sut.hardware.toBlocking().first()?[safe: 3]?.full).to(equal(Strings.PlayerDescription.keyboard(player.keyboard)))
                    try? expect(sut.hardware.toBlocking().first()?[safe: 3]?.highlights).to(equal([player.keyboard]))
                    try? expect(sut.hardware.toBlocking().first()?[safe: 4]?.full).to(equal(Strings.PlayerDescription.headSet(player.headSet)))
                    try? expect(sut.hardware.toBlocking().first()?[safe: 4]?.highlights).to(equal([player.headSet]))
                    
                    try? expect(sut.settings.toBlocking().first()?.count).to(equal(4))
                    try? expect(sut.settings.toBlocking().first()?[safe: 0]?.full).to(equal(Strings.PlayerDescription.effectiveDPI(player.effectiveDPI)))
                    try? expect(sut.settings.toBlocking().first()?[safe: 0]?.highlights).to(equal([player.effectiveDPI]))
                    try? expect(sut.settings.toBlocking().first()?[safe: 1]?.full).to(equal(Strings.PlayerDescription.gameResolution(player.gameResolution)))
                    try? expect(sut.settings.toBlocking().first()?[safe: 1]?.highlights).to(equal([player.gameResolution]))
                    try? expect(sut.settings.toBlocking().first()?[safe: 2]?.full).to(equal(Strings.PlayerDescription.sens(player.windowsSensitivity)))
                    try? expect(sut.settings.toBlocking().first()?[safe: 2]?.highlights).to(equal([player.windowsSensitivity]))
                    try? expect(sut.settings.toBlocking().first()?[safe: 3]?.full).to(equal(Strings.PlayerDescription.pollingRate(player.pollingRate)))
                    try? expect(sut.settings.toBlocking().first()?[safe: 3]?.highlights).to(equal([player.pollingRate]))
                    
                    
                }
            }
        }
    }
}
