//
//  PlayersViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// MARK: Protocol

public protocol PlayersViewModel {
    
}

// MARK: Implementation

private final class PlayersViewModelImpl: PlayersViewModel {
    
    init() {
        
    }
}

// MARK: Factory

public class PlayersViewModelFactory {
    public static func `default`() -> PlayersViewModel {
        return PlayersViewModelImpl()
    }
}
