//
//  NewsDescriptionViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 01.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol NewsDescriptionViewModel {

    
    var closeTrigger: PublishSubject<Void> { get }
    
    var shouldClose: Driver<Void> { get }
}

public final class NewsDescriptionViewModelImpl: NewsDescriptionViewModel {
    public let closeTrigger = PublishSubject<Void>()
    
    public let shouldClose: Driver<Void>
    
    public init(news: NewsPreview,
                newsService: NewsService
    ) {

        shouldClose = closeTrigger.asDriver(onErrorJustReturn: ())
    }
}
