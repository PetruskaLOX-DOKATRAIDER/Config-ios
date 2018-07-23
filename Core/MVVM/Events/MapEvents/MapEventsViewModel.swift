//
//  MapEventsViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol MapEventsViewModel {
     var events: Driver<[EventItemAnnotationViewModel]> { get }
}

public final class MapEventsViewModelImpl: MapEventsViewModel {
    public let events: Driver<[EventItemAnnotationViewModel]>
    
    public init(events: Paginator<Event>) {
        func remapToViewModels(evet: Event) -> EventItemAnnotationViewModel {
            let vm = EventItemAnnotationViewModelImpl(event: evet)
            //vm.selectionTrigger.asDriver(onErrorJustReturn: ()).map{ evemt.detailsURL }.drive(detailURL).disposed(by: vm.rx.disposeBag)
            return vm
        }
        self.events = events.elements.asDriver().map{ $0.map{ remapToViewModels(evet: $0) } }
    }
}
