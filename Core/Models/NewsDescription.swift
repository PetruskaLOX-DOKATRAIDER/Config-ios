//
//  NewsDescription.swift
//  Core
//
//  Created by Oleg Petrychuk on 31.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol NewsContent {}

public struct NewsImageContent: NewsContent {
    public let coverImageURL: URL?
}

public struct NewsTextContent: NewsContent {
    public let text: String
}

public struct NewsDescription {
    public let title: String
    public let date: Date
    public let author: String
    public let moreInfoURL: URL?
    public let id: Int
    public let content: [NewsContent]
}

extension NewsDescription: JSONDecodable {
    public init(json: JSON) throws {
        title = json["subtitle"].stringValue
        date = Date(timeIntervalSince1970: Double(json["date"].stringValue) ?? 0)
        author = json["author"].stringValue
        moreInfoURL = json["link"].url
        id = json["id"].intValue
    
        var content = [NewsContent]()
        json["content"].arrayValue.forEach { contentJSON in
            switch NewsContentType(json: contentJSON) {
            case .image: content.append(NewsImageContent(coverImageURL: contentJSON["image"].url))
            case .text: content.append(NewsTextContent(text: contentJSON["text"].stringValue))
            }
        }
        self.content = content
    }
}

// This logic can become more complex, better to separate it
private enum NewsContentType {
    case image
    case text
    
    init(json: JSON) {
        self = json["isImage"].boolValue ? .image : .text
    }
}
