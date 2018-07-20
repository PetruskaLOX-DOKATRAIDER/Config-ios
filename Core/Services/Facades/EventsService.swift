//
//  EventsService.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol EventsService: AutoMockable {
    func getEvents(forPage page: Int) -> Response<Page<Event>, RequestError>
}

public final class EventsServiceImpl: EventsService, ReactiveCompatible {
    private let dataLoaderHelper: DataLoaderHelper<Event>
    
    public init(
        reachabilityService: ReachabilityService,
        eventsAPIService: EventsAPIService,
        eventsStorage: EventsStorage
    ) {
        dataLoaderHelper = DataLoaderHelper(
            reachabilityService: reachabilityService,
            apiSource: { eventsAPIService.getEvents(forPage: $0) },
            storageSource: { try? eventsStorage.fetchEvents() },
            updateStorage: { try? eventsStorage.update(withNewEvents: $0) }
        )
    }
    
    public func getEvents(forPage page: Int) -> Response<Page<Event>, RequestError> {
        return dataLoaderHelper.loadData(forPage: page)
    }
}
