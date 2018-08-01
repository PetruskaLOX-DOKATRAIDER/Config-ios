//
//  NewsService.swift
//  Core
//
//  Created by Oleg Petrychuk on 31.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol NewsService: AutoMockable {
    func getNewsPreview(forPage page: Int) -> Response<Page<NewsPreview>, RequestError>
    func getPlayerDescription(byID id: Int) -> Response<NewsDescription, RequestError>
}

public final class NewsServiceImpl: NewsService, ReactiveCompatible {
    private let newsPreviewLoaderHelper: PageDataLoaderHelper<NewsPreview>
    private let newsDescriptionLoaderHelper: SingleDataLoaderHelper<NewsDescription>
    
    public init(
        reachabilityService: ReachabilityService,
        eventsAPIService: NewsAPIService,
        eventsStorage: NewsStorage
    ) {
        newsPreviewLoaderHelper = PageDataLoaderHelper(
            reachabilityService: reachabilityService,
            apiSource: { eventsAPIService.getNewsPreview(forPage: $0) },
            storageSource: { try? eventsStorage.fetchNewsPreview() },
            updateStorage: { try? eventsStorage.updateNewsPreview(withNewNews: $0) }
        )
        
        newsDescriptionLoaderHelper = SingleDataLoaderHelper(
            reachabilityService: reachabilityService,
            apiSource: { eventsAPIService.getNewsDescription(byID: $0) },
            storageSource: { try? eventsStorage.fetchNewsDescription(byID: $0) },
            updateStorage: { try? eventsStorage.updateNewsDescription(withNewNews: $0) }
        )
    }
    
    public func getNewsPreview(forPage page: Int) -> Response<Page<NewsPreview>, RequestError> {
        return newsPreviewLoaderHelper.loadData(forPage: page)
    }
    
    public func getPlayerDescription(byID id: Int) -> Response<NewsDescription, RequestError> {
        return newsDescriptionLoaderHelper.loadModel(byID: id)
    }
}
