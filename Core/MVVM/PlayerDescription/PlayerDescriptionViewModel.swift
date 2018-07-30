//
//  PlayerDescriptionViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public typealias PlayerID = Int

public protocol PlayerDescriptionViewModel {
    var fullName: Driver<String> { get }
    var avatarURL: Driver<URL?> { get }
    var personalInfo: Driver<[HighlightText]> { get }
    var hardware: Driver<[HighlightText]> { get }
    var settings: Driver<[HighlightText]> { get }
    var messageViewModel: Driver<MessageViewModel> { get }
    var isWorking: Driver<Bool> { get }
    
    var optionsTrigger: PublishSubject<Void> { get }
    var detailsTrigger: PublishSubject<Void> { get }
    var sendCFGTrigger: PublishSubject<Void> { get }
    var refreshTrigger: PublishSubject<Void> { get }
    var closeTrigger: PublishSubject<Void> { get }
    
    var shouldClose: Driver<Void> { get }
}

public final class PlayerDescriptionViewModelImpl: PlayerDescriptionViewModel {
    public let fullName: Driver<String>
    public let avatarURL: Driver<URL?>
    public let personalInfo: Driver<[HighlightText]>
    public let hardware: Driver<[HighlightText]>
    public let settings: Driver<[HighlightText]>
    public let messageViewModel: Driver<MessageViewModel>
    public let isWorking: Driver<Bool>
    
    public let optionsTrigger = PublishSubject<Void>()
    public let detailsTrigger = PublishSubject<Void>()
    public let sendCFGTrigger = PublishSubject<Void>()
    public let refreshTrigger = PublishSubject<Void>()
    public let closeTrigger = PublishSubject<Void>()
    
    public let shouldClose: Driver<Void>

    public init(
        playerID: PlayerID,
        playersService: PlayersService
    ) {
        let playerRequest = refreshTrigger.asDriver(onErrorJustReturn: ()).flatMapLatest{ playersService.getPlayerDescription(byPlayerID: playerID) }
        fullName = playerRequest.success().map{ "\($0.name) \"\($0.nickname)\" \($0.surname)" }.startWith("")
        avatarURL = playerRequest.success().map{ $0.avatarURL }.startWith(nil)
        personalInfo = playerRequest.success().map{ [
            HighlightText(full: Strings.PlayerDescription.realName("\($0.surname) \($0.name)"), highlights: ["\($0.surname) \($0.name)"]),
            HighlightText(full: Strings.PlayerDescription.nickname($0.nickname), highlights: [$0.nickname]),
            HighlightText(full: Strings.PlayerDescription.fromCountry($0.country), highlights: [$0.country]),
            HighlightText(full: Strings.PlayerDescription.team($0.teamName), highlights: [$0.teamName])
        ] }.startWith([])
        hardware = playerRequest.success().map{ [
            HighlightText(full: Strings.PlayerDescription.mouse($0.mouse), highlights: [$0.mouse]),
            HighlightText(full: Strings.PlayerDescription.mousepad($0.mousepad), highlights: [$0.mousepad]),
            HighlightText(full: Strings.PlayerDescription.monitor($0.monitor), highlights: [$0.monitor]),
            HighlightText(full: Strings.PlayerDescription.keyboard($0.keyboard), highlights: [$0.keyboard]),
            HighlightText(full: Strings.PlayerDescription.headSet($0.headSet), highlights: [$0.headSet])
        ] }.startWith([])
        settings = playerRequest.success().map{ [
            HighlightText(full: Strings.PlayerDescription.effectiveDPI($0.effectiveDPI), highlights: [$0.effectiveDPI]),
            HighlightText(full: Strings.PlayerDescription.gameResolution($0.gameResolution), highlights: [$0.gameResolution]),
            HighlightText(full: Strings.PlayerDescription.sens($0.windowsSensitivity), highlights: [$0.windowsSensitivity]),
            HighlightText(full: Strings.PlayerDescription.pollingRate($0.pollingRate), highlights: [$0.pollingRate])
        ] }.startWith([])
        isWorking = Driver.merge(
            refreshTrigger.asDriver(onErrorJustReturn: ()).map(to: true),
            playerRequest.success().map(to: false),
            playerRequest.failure().map(to: false)
        ).startWith(false)
        
        messageViewModel = playerRequest.failure().map(to: MessageViewModelFactory.error())
        shouldClose = closeTrigger.asDriver(onErrorJustReturn: ())
    }
}
