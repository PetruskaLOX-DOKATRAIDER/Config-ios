//
//  ListEventsViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol ListEventsViewModel {
    var events: Driver<[EventItemViewModel]> { get }
    var shouldOpenURL: Driver<URL> { get }
}

final class ListEventsViewModelImpl: ListEventsViewModel {
    let events: Driver<[EventItemViewModel]>
    let shouldOpenURL: Driver<URL>
    
    init(events: Paginator<Event>) {
        let detailURL = PublishSubject<URL?>()
        func remapToViewModels(event: Event) -> EventItemViewModel {
            let vm = EventItemViewModelImpl(event: event)
            vm.selectionTrigger.asDriver(onErrorJustReturn: ()).map{ event.detailsURL }.drive(detailURL).disposed(by: vm.rx.disposeBag)
            return vm
        }
        shouldOpenURL = detailURL.asDriver(onErrorJustReturn: nil).filterNil()
        self.events = events.elements.asDriver().map{ $0.map{ remapToViewModels(event: $0) } }
    }
}
