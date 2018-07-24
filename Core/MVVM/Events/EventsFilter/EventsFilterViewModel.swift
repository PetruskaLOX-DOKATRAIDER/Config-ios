//
//  EventsFilterViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 24.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol EventsFilterViewModel {
    var cancelTrigger: PublishRelay<Void> { get }
    var applyTrigger: PublishRelay<Void> { get }
    var shouldCloseFilters: Driver<Void> { get }
}

public final class EventsFilterViewModelImpl: EventsFilterViewModel, ReactiveCompatible {
    public let cancelTrigger = PublishRelay<Void>()
    public let applyTrigger = PublishRelay<Void>()
    public let shouldCloseFilters: Driver<Void>
    
    public init(eventsFiltersStorage: EventsFiltersStorage) {
        shouldCloseFilters = Driver.merge(cancelTrigger.asDriver(), applyTrigger.asDriver())
    }
}
