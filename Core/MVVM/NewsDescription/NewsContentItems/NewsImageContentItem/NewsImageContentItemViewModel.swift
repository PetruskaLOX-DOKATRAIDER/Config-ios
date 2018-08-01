//
//  NewsImageContentItemViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 01.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol NewsImageContentItemViewModel {
    var coverImageURL: Driver<URL?> { get }
    var selectionTrigger: PublishSubject<Void> { get }
}

public final class NewsImageContentItemViewModelImpl: NewsImageContentItemViewModel, ReactiveCompatible {
    public let coverImageURL: Driver<URL?>
    public let selectionTrigger = PublishSubject<Void>()
    
    init(newsImageContent: NewsImageContent) {
        coverImageURL = .just(newsImageContent.coverImageURL)
    }
}
