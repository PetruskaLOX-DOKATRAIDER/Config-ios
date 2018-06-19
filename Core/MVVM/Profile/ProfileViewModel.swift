//
//  ProfileViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// MARK: Protocol

public protocol ProfileViewModel {
    
}

// MARK: Implementation

private final class ProfileViewModelImpl: ProfileViewModel {
    
    init() {
        
    }
}

// MARK: Factory

public class ProfileViewModelFactory {
    public static func `default`() -> ProfileViewModel {
        return ProfileViewModelImpl()
    }
}
