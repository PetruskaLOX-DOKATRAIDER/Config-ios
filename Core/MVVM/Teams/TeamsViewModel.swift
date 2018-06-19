//
//  TeamsViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// MARK: Protocol

public protocol TeamsViewModel {
    
}

// MARK: Implementation

private final class TeamsViewModelImpl: TeamsViewModel {
    
    init() {
        
    }
}

// MARK: Factory

public class TeamsViewModelFactory {
    public static func `default`() -> TeamsViewModel {
        return TeamsViewModelImpl()
    }
}
