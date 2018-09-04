//
//  EventsStorageImpl.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 04.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class EventsStorageImpl: EventsStorage, ReactiveCompatible {
    private let eventObjectStorage: CDObjectableStorage<CDEvent>
    
    public init(
        eventObjectStorage: CDObjectableStorage<CDEvent> = CDObjectableStorage()
    ) {
        self.eventObjectStorage = eventObjectStorage
    }
    
    public func update(withNewEvents newEvents: [Event]) -> Driver<Void> {
        return Observable.create{ [weak self] observer -> Disposable in
            self?.eventObjectStorage.update(withNewData: newEvents, completion: {
                observer.onNext(())
                observer.onCompleted()
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: ())
    }
    
    public func fetchEvents() -> Driver<[Event]> {
        return Observable.create{ [weak self] observer -> Disposable in
            self?.eventObjectStorage.fetch(completion: { events in
                observer.onNext(events)
                observer.onCompleted()
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: [])
    }
}
