//
//  NewsTextContentItemViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 01.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol NewsTextContentItemViewModel {
    var text: Driver<String> { get }
}

public final class NewsTextContentItemViewModelImpl: NewsTextContentItemViewModel {
    public let text: Driver<String>
    
    public init(newsTextContent: NewsTextContent) {
        self.text = .just(newsTextContent.text)
    }
}
