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

public protocol EventsService {
    func getEvents(forPage page: Int) -> DriverResult<Page<Event>, EventsServiceError>
}

public final class EventsServiceImpl: EventsService, ReactiveCompatible {
    private let reachabilityService: ReachabilityService
    private let eventsAPIService: EventsAPIService
    private let eventsStorage: EventsStorage
    private let eventsFiltersStorage: EventsFiltersStorage
    
    public init(
        reachabilityService: ReachabilityService,
        eventsAPIService: EventsAPIService,
        eventsStorage: EventsStorage,
        eventsFiltersStorage: EventsFiltersStorage
    ) {
        self.reachabilityService = reachabilityService
        self.eventsAPIService = eventsAPIService
        self.eventsStorage = eventsStorage
        self.eventsFiltersStorage = eventsFiltersStorage
    }

    public func getEvents(forPage page: Int) -> DriverResult<Page<Event>, EventsServiceError> {
        guard reachabilityService.connection != .none else { return getStoredEvents() }
        let request = getRemoteEvents(forPage: page)
        return .merge(updateEvents(request.success()), request.filter{ $0.value == nil })
    }
    
    private func getRemoteEvents(forPage page: Int) -> DriverResult<Page<Event>, EventsServiceError> {
        let request = eventsAPIService.getEvents(forPage: page)
        let noData = request.success().filter{ $0.content.isEmpty }.toVoid()
        let successData = request.success().filter{ $0.content.isNotEmpty }.map{ self.applyFilters($0) }
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
        let data = eventsStorage.fetchEvents().debug("fetchEvents")
        let page = data.map{ Page.new(content: $0, index: 1, totalPages: 1) }.map{ self.applyFilters($0) }
        return .merge(
            page.map{ Result(value: $0) },
            data.filterEmpty().map(to: Result(error: .noData))
        )
    }
    
    private func applyFilters(_ events: Page<Event>) -> Page<Event> {
        let filteredContent = events.content.filter{ event in
            if event.startDate < eventsFiltersStorage.startDate.value ?? Date(timeIntervalSince1970: 0) { return false }
            if event.finishDate > eventsFiltersStorage.finishDate.value ?? Date() { return false }
            if event.countOfTeams < eventsFiltersStorage.maxCountOfTeams.value ?? 0 { return false }
            if event.prizePool < eventsFiltersStorage.minPrizePool.value ?? 1 { return false }
            return true
        }
        return Page.new(content: filteredContent, index: events.index, totalPages: events.totalPages)
    }
}
