//
//  TutorialItemViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 18.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// MARK: Protocol

public protocol TutorialItemViewModel {
    
}

// MARK: Implementation

private final class TutorialItemViewModelImpl: TutorialItemViewModel {
    
}

// MARK: Factory

public class TutorialItemViewModelFactory {
    public static func `default`() -> TutorialItemViewModel {
        return TutorialItemViewModelImpl()
    }
}
