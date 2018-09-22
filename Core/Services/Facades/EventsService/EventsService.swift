//
//  EventsService.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public enum EventsServiceError: Error {
    case serverError(Error)
    case unknown
}

public protocol EventsService: AutoMockable {
    func get(page: Int) -> DriverResult<Page<Core.Event>, EventsServiceError>
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

    public func get(page: Int) -> DriverResult<Page<Event>, EventsServiceError> {
        guard reachabilityService.connection != .none else { return getStored() }
        let request = getRemote(page: page)
        return .merge(update(request.success()), request.filter{ $0.value == nil })
    }
    
    private func getRemote(page: Int) -> DriverResult<Page<Event>, EventsServiceError> {
        let request = eventsAPIService.get(page: page)
        let successData = request.success().filter{ $0.content.isNotEmpty }.map{ self.applyFilters($0) }
        return .merge(
            successData.map{ Result(value: $0) },
            request.failure().map{ Result(error: .serverError($0.localizedDescription)) }
        )
    }
    
    private func update(_ remote: Driver<Page<Event>>) -> DriverResult<Page<Event>, EventsServiceError> {
        return remote.flatMapLatest{ [weak self] page -> Driver<Page<Event>> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.eventsStorage.update(withNew: page.content).map(to: page)
        }.map{ Result(value: $0) }
    }
    
    private func getStored() -> DriverResult<Page<Event>, EventsServiceError> {
        let data = eventsStorage.get()
        let page = data.map{ Page.new(content: $0, index: 1, totalPages: 1) }
        return page.map{ self.applyFilters($0) }.map{ Result(value: $0) }
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

extension EventsServiceError: Equatable {
    public static func == (lhs: EventsServiceError, rhs: EventsServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.serverError, .serverError): return true
        case (.unknown, .unknown): return true
        default: return false
        }
    }
}
