//
//  NewsPreview.swift
//  Core
//
//  Created by Oleg Petrychuk on 31.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public struct NewsPreview {
    public let title: String
    public let coverImageURL: URL?
    public let detailsURL: URL?
    public let id: Int
}

extension NewsPreview: JSONDecodable {
    public init(json: JSON) throws {
        title = json["title"].stringValue
        id = json["id"].intValue
        coverImageURL = json["image"].url
        detailsURL = json["image"].url
    }
}
