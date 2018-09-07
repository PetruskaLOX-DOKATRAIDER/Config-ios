//
//  EventsStorage.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol EventsStorage {
    func update(withNew events: [Event]) -> Driver<Void>
    func get() -> Driver<[Event]>
}
