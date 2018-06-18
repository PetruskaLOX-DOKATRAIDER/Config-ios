//
//  Navigator.swift
//  Core
//
//  Created by Oleg Petrychuk on 15.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// MARK: Protocol

public protocol Navigator {
    func toTutorial()
}

// MARK: Implementation

private final class NavigatorImpl: Navigator, ReactiveCompatible {
    private let router: AppRouterType
    
    init(router: AppRouterType) {
        self.router = router
    }
    
    func toTutorial() {
        
    }
}

// MARK: Factory

public class NavigatorFactory {
    public static func `default`(
        router: AppRouterType = AppRouter.shared
    ) -> Navigator {
        return NavigatorImpl(router: router)
    }
}
