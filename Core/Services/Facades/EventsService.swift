//
//  EventsService.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public enum EventsServiceError: Error {
    case serverError(Error)
    case noData
    case unknown
}

public protocol EventsService: AutoMockable {
    func getEvents(forPage page: Int) -> DriverResult<Page<Event>, EventsServiceError>
}

public final class EventsServiceImpl: EventsService, ReactiveCompatible {
    private let reachabilityService: ReachabilityService
    private let eventsAPIService: EventsAPIService
    private let eventsStorage: EventsStorage
    
    public init(
        reachabilityService: ReachabilityService,
        eventsAPIService: EventsAPIService,
        eventsStorage: EventsStorage
    ) {
        self.reachabilityService = reachabilityService
        self.eventsAPIService = eventsAPIService
        self.eventsStorage = eventsStorage
    }

    public func getEvents(forPage page: Int) -> DriverResult<Page<Event>, EventsServiceError> {
        guard reachabilityService.connection != .none else { return getStoredEvents() }
        let request = getRemoteEvents(forPage: page)
        return .merge(request, updateEvents(request.success()))
    }
    
    private func getRemoteEvents(forPage page: Int) -> DriverResult<Page<Event>, EventsServiceError> {
        let request = eventsAPIService.getEvents(forPage: page)
        let noData = request.success().filter{ $0.content.isEmpty }.toVoid()
        let successData = request.success().filter{ $0.content.isNotEmpty }
        return .merge(
            successData.map{ Result(value: $0) },
            noData.map(to: Result(error: .noData)),
            request.failure().map{ Result(error: .serverError($0.localizedDescription)) }
        )
    }
    
    private func updateEvents(_ remoteEvents: Driver<Page<Event>>) -> DriverResult<Page<Event>, EventsServiceError> {
        return remoteEvents.flatMapLatest{ [weak self] page -> Driver<Page<Event>> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.eventsStorage.update(withNewEvents: page.content).map(to: page)
        }.map{ Result(value: $0) }
    }
    
    private func getStoredEvents() -> DriverResult<Page<Event>, EventsServiceError> {
        let data = eventsStorage.fetchEvents()
        return .merge(
            data.map{ Result(value: Page.new(content: $0, index: 1, totalPages: 1)) },
            data.filterEmpty().map(to: Result(error: .noData))
        )
    }
}
