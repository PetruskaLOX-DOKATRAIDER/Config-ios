//
//  EventsStorage.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol EventsStorage: AutoMockable {
    func update(withNew events: [Core.Event]) -> Driver<Void>
    func get() -> Driver<[Core.Event]>
}
