//
//  MapEventsViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol MapEventsViewModel {
    var events: Driver<[EventItemAnnotationViewModel]> { get }
    var eventDescriptionViewModel: EventDescriptionViewModel { get }
}

public final class MapEventsViewModelImpl: MapEventsViewModel, ReactiveCompatible {
    public let events: Driver<[EventItemAnnotationViewModel]>
    public let eventDescriptionViewModel: EventDescriptionViewModel = EventDescriptionViewModelImpl()
    
    public init(events: Paginator<Event>) {
        let eventTrigger = PublishSubject<Event?>()
        func remapToViewModels(evet: Event) -> EventItemAnnotationViewModel {
            let vm = EventItemAnnotationViewModelImpl(event: evet)
            vm.selectionTrigger.asDriver(onErrorJustReturn: ()).map{ evet }.drive(eventTrigger).disposed(by: vm.disposeBag)
            return vm
        }
        self.events = events.elements.asDriver().map{ $0.map{ remapToViewModels(evet: $0) } }
        if let vm = eventDescriptionViewModel as? EventDescriptionViewModelImpl {
            eventTrigger.asDriver(onErrorJustReturn: nil).filterNil().drive(vm.eventTrigger).disposed(by: rx.disposeBag)
        }
    }
}
