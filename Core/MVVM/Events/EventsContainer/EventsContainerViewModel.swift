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
    var refreshTrigger: PublishSubject<Void> { get }
}

public final class EventsContainerViewModelImpl: EventsContainerViewModel, ReactiveCompatible {
    public let listEventsViewModel: ListEventsViewModel
    public let mapEventsViewModel: MapEventsViewModel
    public let refreshTrigger = PublishSubject<Void>()
    
    public init(eventsService: EventsService) {
        let events = Paginator(factory: { eventsService.getEvents(forPage: $0).success().asObservable() })
        listEventsViewModel = ListEventsViewModelImpl(events: events)
        mapEventsViewModel = MapEventsViewModelImpl(events: events)
        refreshTrigger.flatMapLatest{ events.refreshTrigger }.subscribe().disposed(by: rx.disposeBag)
    }
}
