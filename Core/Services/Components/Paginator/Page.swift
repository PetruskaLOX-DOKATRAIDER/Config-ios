//
//  Page.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TRON
import SwiftyJSON

public struct Page<T> {
    public let content: [T]
    public let index: Int
    public let totalPages: Int
    
    public static var empty: Page<T> {
        return Page(content: [], index: 0, totalPages: 0)
    }
}

extension Page: JSONDecodable {
    public init(json: JSON) {
        if let type = T.self as? JSONDecodable.Type {
            content = json["collection"].arrayValue.flatMap{ json -> Any? in
                do {
                    return try type.init(json: json)
                } catch {
                    print(error.localizedDescription)
                    return nil
                }
            }.flatMap{ $0 as? T }
        } else {
            content = []
        }
        
        index = json["current_page"].intValue
        totalPages = json["total_pages"].intValue
    }
}

public extension Page {
    public static func new(content: [T], index: Int, totalPages: Int) -> Page {
        return Page(content: content, index: index, totalPages: totalPages)
    }
}
