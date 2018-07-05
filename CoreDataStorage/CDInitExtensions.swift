//
//  CDInitExtensions.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 05.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Core
import CoreData

public extension CDImageSize {
    public static func new(conext: NSManagedObjectContext, imageSize: ImageSize) -> CDImageSize {
        let cd = CDImageSize(context: conext)
        cd.height = imageSize.height
        cd.width = imageSize.weight
        return cd
    }
}

public extension CDPlayerPreview {
    public static func new(conext: NSManagedObjectContext, player: PlayerPreview) -> CDPlayerPreview {
        let cd = CDPlayerPreview(context: conext)
        cd.nickname = player.nickname
        cd.profileImageSize = CDImageSize.new(conext: conext, imageSize: player.profileImageSize)
        cd.avatarURL = player.avatarURL?.absoluteString
        cd.id = Int32(player.id)
        return cd
    }
}

public extension ImageSize {
    public static func new(imageSize: CDImageSize?) -> ImageSize {
        return ImageSize.new(
            height: imageSize?.height ?? 0,
            weight: imageSize?.width ?? 0
        )
    }
}

public extension PlayerPreview {
    public static func new(player: CDPlayerPreview) -> PlayerPreview {
        return PlayerPreview.new(
            nickname: player.nickname ?? "",
            profileImageSize: ImageSize.new(imageSize: player.profileImageSize),
            avatarURL: URL(string: player.avatarURL ?? ""),
            id: Int(player.id)
        )
    }
}
