//
//  PlayerInfoViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 06.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol PlayerInfoViewModel {
    var fullName: Driver<String> { get }
    var avatarURL: Driver<URL?> { get }
    var personalInfo: Driver<[HighlightText]> { get }
    var hardware: Driver<[HighlightText]> { get }
    var settings: Driver<[HighlightText]> { get }
}

public final class PlayerInfoViewModelImpl: PlayerInfoViewModel {
    public let fullName: Driver<String>
    public let avatarURL: Driver<URL?>
    public let personalInfo: Driver<[HighlightText]>
    public let hardware: Driver<[HighlightText]>
    public let settings: Driver<[HighlightText]>
    
    public init(player: Driver<PlayerDescription>) {
        fullName = player.map{ "\($0.name) \"\($0.nickname)\" \($0.surname)" }.startWith("")
        avatarURL = player.map{ $0.avatarURL }.startWith(nil)
        personalInfo = player.map{ [
            HighlightText(full: Strings.PlayerDescription.realName("\($0.surname) \($0.name)"), highlights: ["\($0.surname) \($0.name)"]),
            HighlightText(full: Strings.PlayerDescription.nickname($0.nickname), highlights: [$0.nickname]),
            HighlightText(full: Strings.PlayerDescription.fromCountry($0.country), highlights: [$0.country]),
            HighlightText(full: Strings.PlayerDescription.team($0.teamName), highlights: [$0.teamName])
        ] }.startWith([])
        
        hardware = player.map{ [
            HighlightText(full: Strings.PlayerDescription.mouse($0.mouse), highlights: [$0.mouse]),
            HighlightText(full: Strings.PlayerDescription.mousepad($0.mousepad), highlights: [$0.mousepad]),
            HighlightText(full: Strings.PlayerDescription.monitor($0.monitor), highlights: [$0.monitor]),
            HighlightText(full: Strings.PlayerDescription.keyboard($0.keyboard), highlights: [$0.keyboard]),
            HighlightText(full: Strings.PlayerDescription.headSet($0.headSet), highlights: [$0.headSet])
        ] }.startWith([])
        
        settings = player.map{ [
            HighlightText(full: Strings.PlayerDescription.effectiveDPI($0.effectiveDPI), highlights: [$0.effectiveDPI]),
            HighlightText(full: Strings.PlayerDescription.gameResolution($0.gameResolution), highlights: [$0.gameResolution]),
            HighlightText(full: Strings.PlayerDescription.sens($0.windowsSensitivity), highlights: [$0.windowsSensitivity]),
            HighlightText(full: Strings.PlayerDescription.pollingRate($0.pollingRate), highlights: [$0.pollingRate])
        ] }.startWith([])
    }
}
