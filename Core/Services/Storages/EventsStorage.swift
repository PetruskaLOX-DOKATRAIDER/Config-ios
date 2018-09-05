//
//  EventsStorage.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol EventsStorage {
    func update(withNewEvents newEvents: [Event]) -> Driver<Void>
    func fetchEvents() -> Driver<[Event]>
}
