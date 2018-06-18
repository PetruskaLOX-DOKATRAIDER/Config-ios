//
//  AppViewModel.swift
//  GoDrive
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// MARK: Protocol

public protocol AppViewModel {
    
}

// MARK: Implementation

private final class AppViewModelImpl: AppViewModel {
        
}

// MARK: Factory

public class AppViewModelFactory {
    public static func `default`() -> AppViewModel {
        return AppViewModelImpl()
    }
}
