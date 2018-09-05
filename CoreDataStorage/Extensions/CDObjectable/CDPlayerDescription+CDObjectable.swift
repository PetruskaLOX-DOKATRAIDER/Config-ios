//
//  CDPlayerDescription+CDObjectable.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 27.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension CDPlayerDescription: CDObjectable {
    public static func new(conext: NSManagedObjectContext, plainObject: PlayerDescription) -> CDPlayerDescription {
        let cdObject = CDPlayerDescription(context: conext)
        let playerPreview = CDPlayerPreview(context: conext)
        playerPreview.avatarURL = plainObject.avatarURL?.absoluteString
        playerPreview.nickname = plainObject.nickname
        playerPreview.id = Int32(plainObject.id)
        cdObject.playerPreview = playerPreview
        cdObject.id = Int32(plainObject.id)
        cdObject.name = plainObject.name
        cdObject.surname = plainObject.surname
        cdObject.country = plainObject.country
        cdObject.teamName = plainObject.teamName
        cdObject.teamLogoURL = plainObject.teamLogoURL?.absoluteString
        cdObject.flagURL = plainObject.flagURL?.absoluteString
        cdObject.moreInfoURL = plainObject.moreInfoURL?.absoluteString
        cdObject.mouse = plainObject.mouse
        cdObject.mousepad = plainObject.mousepad
        cdObject.monitor = plainObject.monitor
        cdObject.keyboard = plainObject.keyboard
        cdObject.headset = plainObject.headSet
        cdObject.effectiveDPI = plainObject.effectiveDPI
        cdObject.gameResolution = plainObject.gameResolution
        cdObject.windowsSensitivity = plainObject.windowsSensitivity
        cdObject.pollingRate = plainObject.pollingRate
        cdObject.configURL = plainObject.configURL?.absoluteString
        return cdObject
    }
    
    public func compare(withPlainObject plainObject: PlayerDescription) -> Bool {
        return self.id == Int32(plainObject.id)
    }
    
    public func toPlainObject() -> PlayerDescription {
        return PlayerDescription.new(
            id: Int(self.id),
            nickname: self.playerPreview?.nickname ?? "",
            name: self.name ?? "",
            surname: self.surname ?? "",
            avatarURL: URL(string: self.playerPreview?.avatarURL ?? ""),
            country: self.country ?? "",
            teamName: self.teamName ?? "",
            teamLogoURL: URL(string: self.teamLogoURL ?? ""),
            flagURL: URL(string: self.flagURL ?? ""),
            moreInfoURL: URL(string: self.moreInfoURL ?? ""),
            mouse: self.mouse ?? "",
            mousepad: self.mousepad ?? "",
            monitor: self.monitor ?? "",
            keyboard: self.keyboard ?? "",
            headSet: self.headset ?? "",
            effectiveDPI: self.effectiveDPI ?? "",
            gameResolution: self.gameResolution ?? "",
            windowsSensitivity: self.windowsSensitivity ?? "",
            pollingRate: self.pollingRate ?? "",
            configURL: URL(string: self.configURL ?? "")
        )
    }
}

