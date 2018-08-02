//
//  EventsStorage.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol EventsStorage: AutoMockable {
    func update(withNewEvents newEvents: [Event], completion: (() -> Void)?)
    func fetchEvents(completion: (([Event]) -> Void)?)
}
