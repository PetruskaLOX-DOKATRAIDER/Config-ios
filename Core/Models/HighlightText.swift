//
//  HighlightText.swift
//  Core
//
//  Created by Oleg Petrychuk on 23.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public struct HighlightText {
    public let full: String
    public let highlights: [String]
    
    public init(
        full: String,
        highlights: [String] = []
    ) {
        self.full = full
        self.highlights = highlights
    }
}
