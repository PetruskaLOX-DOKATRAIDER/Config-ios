//
//  EventsContainerViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol EventsContainerViewModel {
    var listEventsViewModel: ListEventsViewModel { get }
    var mapEventsViewModel: MapEventsViewModel { get }
    var eventsPaginator: Paginator<Event> { get }
    var filtersTrigger: PublishRelay<Void> { get }
    var shouldRouteFilters: Driver<Void> { get }
}

public final class EventsContainerViewModelImpl: EventsContainerViewModel, ReactiveCompatible {
    public let listEventsViewModel: ListEventsViewModel
    public let mapEventsViewModel: MapEventsViewModel
    public let eventsPaginator: Paginator<Event>
    public let filtersTrigger = PublishRelay<Void>()
    public let shouldRouteFilters: Driver<Void>
    
    public init(eventsService: EventsService) {
        eventsPaginator = Paginator(factory: { eventsService.getEvents(forPage: $0).success().asObservable() })
        listEventsViewModel = ListEventsViewModelImpl(events: eventsPaginator)
        mapEventsViewModel = MapEventsViewModelImpl(events: eventsPaginator)
        shouldRouteFilters = filtersTrigger.asDriver()
    }
}
