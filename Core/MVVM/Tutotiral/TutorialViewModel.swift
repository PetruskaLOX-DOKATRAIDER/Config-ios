//
//  TutorialViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 18.06.2018.
//Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// MARK: Protocol

public protocol TutorialViewModel {
    
}

// MARK: Implementation

private final class TutorialViewModelImpl: TutorialViewModel {
    
}

// MARK: Factory

public class TutorialViewModelFactory {
    public static func `default`() -> TutorialViewModel {
        return TutorialViewModelImpl()
    }
}
