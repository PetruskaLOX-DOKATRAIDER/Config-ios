//
//  Storage+Events.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class EventsStorageImpl: EventsStorage, ReactiveCompatible {
    private let coreDataStorage: CoreDataStorage<CDEvent>
    
    public init(coreDataStorage: CoreDataStorage<CDEvent> = CoreDataStorage()) {
        self.coreDataStorage = coreDataStorage
    }
    
    public func update(withNewEvents newEvents: [Event]) throws {
        try? coreDataStorage.update(withNewData: newEvents)
    }
    
    public func fetchEvents() throws -> [Event] {
        do {
            return try coreDataStorage.fetch()
        } catch {
            throw CoreDataStorageError.unknown
        }
    }
}
