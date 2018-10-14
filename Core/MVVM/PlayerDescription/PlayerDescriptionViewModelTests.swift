//
//  PlayerDescriptionViewModelTests.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class PlayerDescriptionViewModelTests: BaseTestCase {
    override func spec() {
        describe("PlayerDescriptionViewModel") {            
            //swiftlint:disable:next line_length
            let player = PlayerDescription.new(id: Int.random(), nickname: String.random(), name: String.random(), surname: String.random(), avatarURL: URL.new(), country: String.random(), teamName: String.random(), teamLogoURL: URL.new(), flagURL: URL.new(), moreInfoURL: URL.new(), mouse: String.random(), mousepad: String.random(), monitor: String.random(), keyboard: String.random(), headSet: String.random(), effectiveDPI: String.random(), gameResolution: String.random(), windowsSensitivity: String.random(), pollingRate: String.random(), configURL: URL.new())
            var playersService: PlayersServiceMock!
            var pasteboardService: PasteboardServiceMock!
            var userStorage: UserStorageMock!
            var emailService: EmailServiceMock!
            var sut: PlayerDescriptionViewModel!
            
            beforeEach {
                playersService = PlayersServiceMock()
                playersService.getDescriptionPlayerReturnValue = .just(Result(error: .unknown))
                playersService.addFavouriteReturnValue = .just(Result(value: ()))
                playersService.removeFavouriteReturnValue = .just(Result(value: ()))
                pasteboardService = PasteboardServiceMock()
                userStorage = UserStorageMock(isOnboardingPassed: BehaviorRelay(value: false), email: BehaviorRelay(value: nil))
                emailService = EmailServiceMock()
                sut = PlayerDescriptionViewModelImpl(player: player.id, playersService: playersService, pasteboardService: pasteboardService, userStorage: userStorage, emailService: emailService)
            }
        
            describe("when calling refresh did trigger") {
                context("and received data") {
                    it("should have valid PlayerInfo VM") {
                        let avatarObserver = self.scheduler.createObserver(URL?.self)
                        sut.playerInfoViewModel.avatarURL.drive(avatarObserver).disposed(by: self.disposeBag)
                        let nameObserver = self.scheduler.createObserver(String.self)
                        sut.playerInfoViewModel.fullName.drive(nameObserver).disposed(by: self.disposeBag)
                        playersService.getDescriptionPlayerReturnValue = .just(Result(value: player))
                        
                        sut.refreshTrigger.onNext(())
                        
                        try? expect(sut.playerInfoViewModel.fullName.toBlocking().first()).to(equal("\(player.name) \"\(player.nickname)\" \(player.surname)"))
                        try? expect(sut.playerInfoViewModel.avatarURL.filterNil().toBlocking().first()).to(equal(player.avatarURL))
                    }
                    
                    it("should stop working") {
                        let observer = self.scheduler.createObserver(Bool.self)
                        sut.isWorking.drive(observer).disposed(by: self.disposeBag)
                        playersService.getDescriptionPlayerReturnValue = .just(Result(value: player))
                        
                        sut.refreshTrigger.onNext(())
                        
                        try? expect(sut.isWorking.toBlocking().first()).to(beFalsy())
                    }
                }
                
                context("and received error") {
                    it("should have valid PlayerInfo VM") {
                        let avatarObserver = self.scheduler.createObserver(URL?.self)
                        sut.playerInfoViewModel.avatarURL.drive(avatarObserver).disposed(by: self.disposeBag)
                        let nameObserver = self.scheduler.createObserver(String.self)
                        sut.playerInfoViewModel.fullName.drive(nameObserver).disposed(by: self.disposeBag)
                        playersService.getDescriptionPlayerReturnValue = .just(Result(error: .unknown))
                        
                        sut.refreshTrigger.onNext(())
                        
                        try? expect(sut.playerInfoViewModel.fullName.toBlocking().first()).to(equal(""))
                        try? expect(sut.playerInfoViewModel.avatarURL.toBlocking().first().flatMap{ $0 }).to(beNil())
                    }
                    
                    it("should stop working") {
                        let observer = self.scheduler.createObserver(Bool.self)
                        sut.isWorking.drive(observer).disposed(by: self.disposeBag)
                        playersService.getDescriptionPlayerReturnValue = .just(Result(error: .unknown))
                        
                        sut.refreshTrigger.onNext(())
                        
                        try? expect(sut.isWorking.toBlocking().first()).to(beFalsy())
                    }
                    
                    it("should show error message") {
                        let observer = self.scheduler.createObserver(MessageViewModel.self)
                        sut.messageViewModel.drive(observer).disposed(by: self.disposeBag)
                        playersService.getDescriptionPlayerReturnValue = .just(Result(error: .unknown))
                        
                        sut.refreshTrigger.onNext(())
                        
                        expect(observer.events.count).to(equal(1))
                    }
                }
            }
            
            describe("when calling options did trigger") {
                it("should show valid alert") {
                    let observer = self.scheduler.createObserver(AlertViewModel.self)
                    sut.alertViewModel.drive(observer).disposed(by: self.disposeBag)
                    playersService.isFavouritePlayerReturnValue = .just(Result(value: true))
                    sut.refreshTrigger.onNext(())
                    
                    sut.optionsTrigger.onNext(())
                    
                    try? expect(sut.alertViewModel.toBlocking().first()?.title).to(equal(Strings.PlayerDescription.options))
                    try? expect(sut.alertViewModel.toBlocking().first()?.actions.count).to(equal(4))
                    try? expect(sut.alertViewModel.toBlocking().first()?.actions[safe: 0]?.title).to(equal(Strings.PlayerDescription.copyCfg))
                    try? expect(sut.alertViewModel.toBlocking().first()?.actions[safe: 1]?.title).to(equal(Strings.PlayerDescription.shareCfg))
                    try? expect(sut.alertViewModel.toBlocking().first()?.actions[safe: 3]?.title).to(equal(Strings.PlayerDescription.cancel))
                    try? expect(sut.alertViewModel.toBlocking().first()?.style).to(equal(.actionSheet))
                }
                
                context("and player is favorite") {
                    it("should show alert with remove button") {
                        let observer = self.scheduler.createObserver(AlertViewModel.self)
                        sut.alertViewModel.drive(observer).disposed(by: self.disposeBag)
                        playersService.isFavouritePlayerReturnValue = .just(Result(value: true))
                        sut.refreshTrigger.onNext(())
                        
                        sut.optionsTrigger.onNext(())
                        
                        try? expect(sut.alertViewModel.toBlocking().first()?.actions[safe: 2]?.title).to(equal(Strings.PlayerDescription.removeFromFavorites))
                    }
                }
                
                context("and player isn't favorite") {
                    it("should show alert with add button") {
                        let observer = self.scheduler.createObserver(AlertViewModel.self)
                        sut.alertViewModel.drive(observer).disposed(by: self.disposeBag)
                        playersService.isFavouritePlayerReturnValue = .just(Result(value: false))
                        sut.refreshTrigger.onNext(())
                        
                        sut.optionsTrigger.onNext(())
                        
                        try? expect(sut.alertViewModel.toBlocking().first()?.actions[safe: 2]?.title).to(equal(Strings.PlayerDescription.addToFavorites))
                    }
                }
            }
            
            describe("when option copy player CFG url in alert did trigger") {
                it("should copy player CFG url") {
                    let observer = self.scheduler.createObserver(AlertViewModel.self)
                    sut.alertViewModel.drive(observer).disposed(by: self.disposeBag)
                    let messageObserver = self.scheduler.createObserver(MessageViewModel.self)
                    sut.messageViewModel.drive(messageObserver).disposed(by: self.disposeBag)
                    playersService.getDescriptionPlayerReturnValue = .just(Result(value: player))
                    playersService.isFavouritePlayerReturnValue = .just(Result(value: true))
                    sut.refreshTrigger.onNext(())
                    sut.optionsTrigger.onNext(())
                    
                    try? sut.alertViewModel.toBlocking().first()?.actions[safe: 0]?.action?.onNext(())
                    
                    expect(pasteboardService.saveStringReceived).to(equal(player.configURL?.absoluteString))
                }
                
                it("should show message that player cfg url has been saved") {
                    let alertObserver = self.scheduler.createObserver(AlertViewModel.self)
                    sut.alertViewModel.drive(alertObserver).disposed(by: self.disposeBag)
                    let messageObserver = self.scheduler.createObserver(MessageViewModel.self)
                    sut.messageViewModel.drive(messageObserver).disposed(by: self.disposeBag)
                    playersService.getDescriptionPlayerReturnValue = .just(Result(value: player))
                    playersService.isFavouritePlayerReturnValue = .just(Result(value: true))
                    sut.refreshTrigger.onNext(())
                    sut.optionsTrigger.onNext(())
                    
                    try? sut.alertViewModel.toBlocking().first()?.actions[safe: 0]?.action?.onNext(())
                    
                    try? expect(sut.messageViewModel.toBlocking().first()?.description.toBlocking().first()).to(equal(Strings.PlayerDescription.copiedMessage))
                }
            }
            
            describe("when option share player CFG url in alert did trigger") {
                it("should share player CFG url") {
                    let alertObserver = self.scheduler.createObserver(AlertViewModel.self)
                    sut.alertViewModel.drive(alertObserver).disposed(by: self.disposeBag)
                    let shareObserver = self.scheduler.createObserver(ShareItem.self)
                    sut.shouldShare.drive(shareObserver).disposed(by: self.disposeBag)
                    playersService.getDescriptionPlayerReturnValue = .just(Result(value: player))
                    playersService.isFavouritePlayerReturnValue = .just(Result(value: true))
                    sut.refreshTrigger.onNext(())
                    sut.optionsTrigger.onNext(())
                    
                    try? sut.alertViewModel.toBlocking().first()?.actions[safe: 1]?.action?.onNext(())
                    
                    try? expect(sut.shouldShare.toBlocking().first()?.url).to(equal(player.configURL))
                }
            }
            
            describe("when option add player to favorites in alert did trigger") {
                it("should add player to favorites") {
                    let observer = self.scheduler.createObserver(AlertViewModel.self)
                    sut.alertViewModel.drive(observer).disposed(by: self.disposeBag)
                    let messageObserver = self.scheduler.createObserver(MessageViewModel.self)
                    sut.messageViewModel.drive(messageObserver).disposed(by: self.disposeBag)
                    playersService.getDescriptionPlayerReturnValue = .just(Result(value: player))
                    playersService.isFavouritePlayerReturnValue = .just(Result(value: false))
                    sut.refreshTrigger.onNext(())
                    sut.optionsTrigger.onNext(())
                    
                    try? sut.alertViewModel.toBlocking().first()?.actions[safe: 2]?.action?.onNext(())
                    
                    expect(playersService.addFavouriteReceived).to(equal(player.id))
                }
            }
            
            describe("when option remove player from favorites in alert did trigger") {
                it("should remove player from favorites") {
                    let observer = self.scheduler.createObserver(AlertViewModel.self)
                    sut.alertViewModel.drive(observer).disposed(by: self.disposeBag)
                    let messageObserver = self.scheduler.createObserver(MessageViewModel.self)
                    sut.messageViewModel.drive(messageObserver).disposed(by: self.disposeBag)
                    playersService.getDescriptionPlayerReturnValue = .just(Result(value: player))
                    playersService.isFavouritePlayerReturnValue = .just(Result(value: true))
                    sut.refreshTrigger.onNext(())
                    sut.optionsTrigger.onNext(())
                    
                    try? sut.alertViewModel.toBlocking().first()?.actions[safe: 2]?.action?.onNext(())
                    
                    expect(playersService.removeFavouriteReceived).to(equal(player.id))
                }
            }
            
            
            describe("when calling details did trigger") {
                context("and received data") {
                    it("should open player more info url") {
                        let observer = self.scheduler.createObserver(URL.self)
                        sut.shouldOpenURL.drive(observer).disposed(by: self.disposeBag)
                        playersService.getDescriptionPlayerReturnValue = .just(Result(value: player))
                        sut.refreshTrigger.onNext(())
                        
                        sut.detailsTrigger.onNext(())

                        try? expect(sut.shouldOpenURL.toBlocking().first()).to(equal(player.moreInfoURL))
                    }
                }
                
                context("and received error") {
                    it("shouldn't open url") {
                        let observer = self.scheduler.createObserver(URL.self)
                        sut.shouldOpenURL.drive(observer).disposed(by: self.disposeBag)
                        playersService.getDescriptionPlayerReturnValue = .just(Result(error: .unknown))
                        sut.refreshTrigger.onNext(())
                        
                        sut.detailsTrigger.onNext(())

                        expect(observer.events.count).to(equal(0))
                    }
                }
            }
            
            describe("when calling send CFG did trigger") {
                context("and received success") {
                    it("should send vaild email to user's email") {
                        let observer = self.scheduler.createObserver(MessageViewModel.self)
                        sut.messageViewModel.drive(observer).disposed(by: self.disposeBag)
                        playersService.getDescriptionPlayerReturnValue = .just(Result(value: player))
                        emailService.sendWithInfoReturnValue = .just(Result(error: .noAccount))
                        userStorage.email.accept(String.random())
                        sut.refreshTrigger.onNext(())
                        
                        sut.sendCFGTrigger.onNext(())
                        
                        expect(emailService.sendWithInfoReceived?.recipients.first).to(equal(userStorage.email.value))
                        expect(emailService.sendWithInfoReceived?.subject).to(equal(Strings.PlayerDescription.sendCfg))
                        expect(emailService.sendWithInfoReceived?.message).to(equal(player.configURL?.absoluteString))
                    }
                }
                
                context("and received error") {
                    it("should send error message") {
                        let observer = self.scheduler.createObserver(MessageViewModel.self)
                        sut.messageViewModel.drive(observer).disposed(by: self.disposeBag)
                        playersService.getDescriptionPlayerReturnValue = .just(Result(value: player))
                        emailService.sendWithInfoReturnValue = .just(Result(error: .noAccount))
                        sut.refreshTrigger.onNext(())
                        
                        sut.sendCFGTrigger.onNext(())
                        
                        try? expect(sut.messageViewModel.toBlocking().first()?.description.toBlocking().first()).to(equal(Strings.PlayerDescription.noEmailAcc))
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
