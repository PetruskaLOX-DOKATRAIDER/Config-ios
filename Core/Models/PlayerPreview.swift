//
//  PlayerPreview.swift
//  Core
//
//  Created by Oleg Petrychuk on 19.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import SwiftyJSON
import TRON

public struct ImageSize {
    public let height: Double
    public let weight: Double
}

public struct PlayerPreview {
    public let nickname: String
    public let profileImageSize: ImageSize
    public let avatarURL: URL?
    public let id: Int
}

extension PlayerPreview: JSONDecodable {
    public init(json: JSON) throws {
        let imageSizeArray = json["imageResolution"].stringValue.components(separatedBy: "x")
        nickname = json["nickName"].stringValue
        profileImageSize = ImageSize(height: Double(imageSizeArray.first ?? "") ?? 0, weight: Double(imageSizeArray.last ?? "") ?? 0)
        avatarURL = json["image"].url
        id = json["id"].intValue
    }
}
