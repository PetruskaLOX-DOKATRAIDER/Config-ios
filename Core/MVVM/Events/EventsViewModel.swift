//
//  EventsViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// MARK: Protocol

public protocol EventsViewModel {
    
}

// MARK: Implementation

private final class EventsViewModelImpl: EventsViewModel {
    
    init() {
        
    }
}

// MARK: Factory

public class EventsViewModelFactory {
    public static func `default`() -> EventsViewModel {
        return EventsViewModelImpl()
    }
}
