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
    var isDescriptionAvailable: Driver<Bool> { get }
    var unFocusTrigger: PublishSubject<Void> { get }
}

public final class MapEventsViewModelImpl: MapEventsViewModel, ReactiveCompatible {
    public let events: Driver<[EventItemAnnotationViewModel]>
    public let eventDescriptionViewModel: EventDescriptionViewModel
    public let isDescriptionAvailable: Driver<Bool>
    public let unFocusTrigger = PublishSubject<Void>()
    
    public init(events: Paginator<Event>) {
        let itemTrigger = PublishSubject<Event?>()
        func remapToViewModels(evet: Event) -> EventItemAnnotationViewModel {
            let vm = EventItemAnnotationViewModelImpl(event: evet)
            vm.selectionTrigger.asDriver(onErrorJustReturn: ()).map{ evet }.drive(itemTrigger).disposed(by: vm.disposeBag)
            return vm
        }
        self.events = events.elements.asDriver().map{ $0.map{ remapToViewModels(evet: $0) } }
        isDescriptionAvailable = Driver.merge(
            unFocusTrigger.asDriver(onErrorJustReturn: ()).map(to: false),
            itemTrigger.asDriver(onErrorJustReturn: nil).filterNil().map(to: true)
        ).startWith(false)
        let eventDescriptionVM = EventDescriptionViewModelImpl()
        self.eventDescriptionViewModel = eventDescriptionVM
        itemTrigger.asDriver(onErrorJustReturn: nil).filterNil().drive(eventDescriptionVM.eventTrigger).disposed(by: rx.disposeBag)
    }
}
