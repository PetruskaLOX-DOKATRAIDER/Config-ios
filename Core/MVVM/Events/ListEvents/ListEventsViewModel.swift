//
//  ListEventsViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol ListEventsViewModel {
    var events: Driver<[EventItemViewModel]> { get }
    var eventDetailsURLTrigger: Driver<URL> { get }
}

final class ListEventsViewModelImpl: ListEventsViewModel {
    let events: Driver<[EventItemViewModel]>
    let eventDetailsURLTrigger: Driver<URL>
    
    init(events: Paginator<Event>) {
        let detailURL = PublishSubject<URL?>()
        func remapToViewModels(evemt: Event) -> EventItemViewModel {
            let vm = EventItemViewModelImpl(event: evemt)
            vm.selectionTrigger.asDriver(onErrorJustReturn: ()).map{ evemt.detailsURL }.drive(detailURL).disposed(by: vm.rx.disposeBag)
            return vm
        }
        eventDetailsURLTrigger = detailURL.asDriver(onErrorJustReturn: nil).filterNil()
        self.events = events.elements.asDriver().map{ $0.map{ remapToViewModels(evemt: $0) } }
    }
}
