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
    var filtersTrigger: PublishSubject<Void> { get }
    var shouldRouteFilters: Driver<Void> { get }
}

public final class EventsContainerViewModelImpl: EventsContainerViewModel, ReactiveCompatible {
    public let listEventsViewModel: ListEventsViewModel
    public let mapEventsViewModel: MapEventsViewModel
    public let eventsPaginator: Paginator<Event>
    public let filtersTrigger = PublishSubject<Void>()
    public let shouldRouteFilters: Driver<Void>
    
    public init(
        eventsService: EventsService,
        eventsFiltersStorage: EventsFiltersStorage,
        imageLoaderService: ImageLoaderService
    ) {
        eventsPaginator = Paginator(factory:{ eventsService.get(page: $0).success().asObservable() })
        listEventsViewModel = ListEventsViewModelImpl(events: eventsPaginator)
        mapEventsViewModel = MapEventsViewModelImpl(events: eventsPaginator, imageLoaderService: imageLoaderService)
        shouldRouteFilters = filtersTrigger.asDriver(onErrorJustReturn: ())
        Driver.merge(
            eventsFiltersStorage.startDate.asDriver().map(to: ()),
            eventsFiltersStorage.finishDate.asDriver().map(to: ()),
            eventsFiltersStorage.maxCountOfTeams.asDriver().map(to: ()),
            eventsFiltersStorage.minPrizePool.asDriver().map(to: ())
        ).throttle(0.5).drive(eventsPaginator.refreshTrigger).disposed(by: rx.disposeBag)
    }
}
