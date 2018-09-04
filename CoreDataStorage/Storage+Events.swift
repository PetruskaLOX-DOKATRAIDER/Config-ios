//
//  Storage+Events.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class EventsStorageImpl: EventsStorage, ReactiveCompatible {
    private let coreDataStorage: CoreDataStorage<CDEvent>
    
    public init(
        coreDataStorage: CoreDataStorage<CDEvent> = CoreDataStorage()
    ) {
        self.coreDataStorage = coreDataStorage
    }
    
    public func update(withNewEvents newEvents: [Event]) -> Driver<Void> {
        return Observable.create{ [weak self] observer -> Disposable in
            self?.coreDataStorage.update(withNewData: newEvents, completion: {
                observer.onNext(())
                observer.onCompleted()
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: ())
    }
    
    public func fetchEvents() -> Driver<[Event]> {
        return Observable.create{ [weak self] observer -> Disposable in
            self?.coreDataStorage.fetch(completion: { events in
                observer.onNext(events)
                observer.onCompleted()
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: [])
    }
}
