//
//  PlayerBanner.swift
//  Core
//
//  Created by Oleg Petrychuk on 19.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import SwiftyJSON
import TRON

public struct PlayerBanner {
    public let coverImageURL: URL?
    public let id: Int
    public let updatedDate: Date
}

extension PlayerBanner: JSONDecodable {
    public init(json: JSON) throws {
        coverImageURL = json["imageLink"].url
        id = json["id"].intValue
        updatedDate = Date(timeIntervalSince1970: Double(json["date"].stringValue) ?? 0)
    }
}
