//
//  NewsService.swift
//  Core
//
//  Created by Oleg Petrychuk on 31.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol NewsService: AutoMockable {
    func getNewsPreview(forPage page: Int) -> Response<Page<NewsPreview>, RequestError>
    //func getPlayerDescription(byID id: Int) -> Response<PlayerDescription, RequestError>
}

public final class NewsServiceImpl: NewsService, ReactiveCompatible {
    //private let dataLoaderHelper: PageDataLoaderHelper<NewsPreview>
    
    public init(
        reachabilityService: ReachabilityService,
        eventsAPIService: EventsAPIService,
        eventsStorage: EventsStorage
    ) {
//        dataLoaderHelper = PageDataLoaderHelper(
//            reachabilityService: reachabilityService,
//            apiSource: { eventsAPIService.getEvents(forPage: $0) },
//            storageSource: { try? eventsStorage.fetchEvents() },
//            updateStorage: { try? eventsStorage.update(withNewEvents: $0) }
//        )
    }
    
    public func getNewsPreview(forPage page: Int) -> Response<Page<NewsPreview>, RequestError> {
        //return dataLoaderHelper.loadData(forPage: page)
    }
}
