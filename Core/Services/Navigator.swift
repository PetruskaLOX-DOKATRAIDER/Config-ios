//
//  Navigator.swift
//  Core
//
//  Created by Oleg Petrychuk on 15.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// MARK: Protocol

public protocol Navigator {}

// MARK: Implementation

private final class NavigatorImpl: Navigator, ReactiveCompatible {
    private let router: AppRouterType
    
    init(router: AppRouterType, appViewModel: AppViewModel) {
        self.router = router
        
        func toTutorial() {
            let viewController = TutorialViewControllerFactory.default()
            let navigationController = NavigationControllerFactory.new()
            navigationController.setViewControllers([viewController], animated: false)
            router.window.rootViewController = navigationController
            router.window.makeKeyAndVisible()
        }
        
        appViewModel.shouldRouteTutorial.drive(onNext: {
            toTutorial()
        }).disposed(by: rx.disposeBag)
    }
}

// MARK: Factory

public class NavigatorFactory {
    public static func `default`(
        router: AppRouterType = AppRouter.shared,
        appViewModel: AppViewModel
    ) -> Navigator {
        return NavigatorImpl(router: router, appViewModel: appViewModel)
    }
}
