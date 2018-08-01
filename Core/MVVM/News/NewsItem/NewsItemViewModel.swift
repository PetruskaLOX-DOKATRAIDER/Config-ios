//
//  NewsItemViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 31.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol NewsItemViewModel {
    var title: Driver<String> { get }
    var coverImage: Driver<URL?> { get }
    var selectionTrigger: PublishSubject<Void> { get }
    var shareTrigger: PublishSubject<Void> { get }
}

public final class NewsItemViewModelImpl: NewsItemViewModel, ReactiveCompatible {
    public let title: Driver<String>
    public let coverImage: Driver<URL?>
    public let selectionTrigger = PublishSubject<Void>()
    public let shareTrigger = PublishSubject<Void>()
    
    public init(news: NewsPreview) {
        title = .just(news.title)
        coverImage = .just(news.coverImageURL)
    }
}
