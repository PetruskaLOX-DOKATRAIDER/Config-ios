//
//  PlayerDescription.swift
//  Core
//
//  Created by Oleg Petrychuk on 19.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import SwiftyJSON
import TRON

public struct PlayerDescription {
    public let id: Int
    public let nickname: String
    public let name: String
    public let surname: String
    public let avatarURL: URL?
    public let country: String
    public let teamName: String
    public let teamLogoURL: URL?
    public let flagURL: URL?
    public let moreInfoURL: URL?
    public let mouse: String
    public let mousepad: String
    public let monitor: String
    public let keyboard: String
    public let headSet: String
    public let effectiveDPI: String
    public let gameResolution: String
    public let windowsSensitivity: String
    public let pollingRate: String
    public let configURL: URL?
    
    public init(xyq: Int, nickname: String, name: String, surname: String, avatarURL: URL?, country: String, teamName: String,
                teamLogoURL: URL?, flagURL: URL?, moreInfoURL: URL?, mouse: String, mousepad: String, monitor: String, keyboard: String,
                headSet: String, effectiveDPI: String, gameResolution: String, windowsSensitivity: String, pollingRate: String, configURL: URL?) {
        self.id = xyq
        self.nickname = nickname
        self.name = name
        self.surname = surname
        self.avatarURL = avatarURL
        self.country = country
        self.teamName = teamName
        self.teamLogoURL = teamLogoURL
        self.flagURL = flagURL
        self.moreInfoURL = moreInfoURL
        self.mouse = mouse
        self.mousepad = mousepad
        self.monitor = monitor
        self.keyboard = keyboard
        self.headSet = headSet
        self.effectiveDPI = effectiveDPI
        self.gameResolution = gameResolution
        self.windowsSensitivity = windowsSensitivity
        self.pollingRate = pollingRate
        self.configURL = configURL
    }
}

extension PlayerDescription: JSONDecodable {
    public init(json: JSON) throws {
        id = json["id"].intValue
        nickname = json["nick"].stringValue
        name = json["name"].stringValue
        surname = json["surName"].stringValue
        avatarURL = json["image"].url
        country = json["country"].stringValue
        teamName = json[""].stringValue
        teamLogoURL = json["teamImage"].url
        flagURL = json["flagImage"].url
        moreInfoURL = json["moreInfoLink"].url
        mouse = json["mouse"].stringValue
        mousepad = json["mousepad"].stringValue
        monitor = json["monitor"].stringValue
        keyboard = json["keyboard"].stringValue
        headSet = json["headSet"].stringValue
        effectiveDPI = json["Effective DPI"].stringValue
        gameResolution = json["InGameResolution"].stringValue
        windowsSensitivity = json["windowsSen"].stringValue
        pollingRate = json["PollingRate"].stringValue
        configURL = json["downloadLink"].url
    }
}
