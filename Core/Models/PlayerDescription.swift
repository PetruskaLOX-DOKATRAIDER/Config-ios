//
//  PlayerDescription.swift
//  Core
//
//  Created by Oleg Petrychuk on 19.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

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
