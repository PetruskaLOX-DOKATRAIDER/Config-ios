//
//  Team.swift
//  Core
//
//  Created by Oleg Petrychuk on 16.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import SwiftyJSON
import TRON

public struct Team {
    public let name: String
    public let logoURL: URL?
    public let id: Int
    public let players: [PlayerPreview]
}

extension Team: JSONDecodable {
    public init(json: JSON) throws {
        name = json["teamName"].stringValue
        logoURL = json["image"].url
        id = json["id"].intValue
        players = json["players"].arrayValue.flatMap{ json -> Any? in
            do {
                return try PlayerPreview(json: json)
            } catch {
                return nil
            }
        }.flatMap{ $0 as? PlayerPreview }
    }
}
