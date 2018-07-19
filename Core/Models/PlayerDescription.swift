//
//  PlayerDescription.swift
//  Core
//
//  Created by Oleg Petrychuk on 19.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import SwiftyJSON
import TRON

struct PlayerDescription {
    let id: Int
    let nickname: String
    let name: String
    let surname: String
    let profileImageURL: URL?
    let country: String
    let teamName: String
    let teamImageURL: URL?
    let flagImageURL: URL?
    let moreInfoURL: URL?
    let mouse: String
    let mousepad: String
    let monitor: String
    let keyboard: String
    let headSet: String
    let effectiveDPI: String
    let gameResolution: String
    let windowsSensitivity: String
    let pollingRate: String
    let downloadURL: URL?
}

extension PlayerDescription: JSONDecodable {
    public init(json: JSON) throws {
        id = json["id"].intValue
        nickname = json["nick"].stringValue
        name = json["name"].stringValue
        surname = json["surName"].stringValue
        profileImageURL = json["image"].url
        country = json["country"].stringValue
        teamName = json[""].stringValue
        teamImageURL = json["teamImage"].url
        flagImageURL = json["flagImage"].url
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
        downloadURL = json["downloadLink"].url
    }
}
