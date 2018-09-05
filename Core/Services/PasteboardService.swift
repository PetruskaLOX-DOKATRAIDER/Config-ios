//
//  PasteboardService.swift
//  Core
//
//  Created by Oleg Petrychuk on 05.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol PasteboardService {
    func save(_ string: String)
    func saved() -> String?
}

public final class PasteboardServiceImpl: PasteboardService, ReactiveCompatible {
    private let pasteboard: UIPasteboard
    
    public init(pasteboard: UIPasteboard = .general) {
        self.pasteboard = pasteboard
    }
    
    public func save(_ string: String) {
        pasteboard.string = string
    }
    
    public func saved() -> String? {
        return pasteboard.string
    }
    
}
