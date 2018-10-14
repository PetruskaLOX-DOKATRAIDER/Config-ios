//
//  ShareItem.swift
//  Core
//
//  Created by Oleg Petrychuk on 27.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public struct ShareItem {
    public let text: String?
    public let url: URL?
    public let image: UIImage?
    
    public init(
        text: String? = nil,
        url: URL? = nil,
        image: UIImage? = nil
    ) {
        self.text = text
        self.url = url
        self.image = image
    }
    
    public func items() -> [Any] {
        return [text as Any, url as Any, image as Any].compactMap{ $0 }
    }
}
