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
        appViewModel.shouldRouteTutorial.drive(onNext: { [weak self] in
            self?.toTutorial()
        }).disposed(by: rx.disposeBag)
        appViewModel.shouldRouteApp.drive(onNext: { [weak self] in
            self?.toMainTabs()
        }).disposed(by: rx.disposeBag)
    }
    
    private func toTutorial() {
        let tutorial = assemblyTutorial()
        router.window.rootViewController = tutorial
        router.window.makeKeyAndVisible()
    }
    
    private func toMainTabs() {
        let tabBarController = TabBarControllerFactory.new(withViewControllers: [
            assemblyPlayers(),
            assemblyTeams(),
            assemblyEvents(),
            assemblyNews(),
            assemblyProfile()
        ])
        UIView.transition(with: router.window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.router.window.rootViewController = tabBarController
        })
    }
    
    private func assemblyTutorial() -> UIViewController {
        let viewModel = TutorialViewModelFactory.default()
        viewModel.shouldRouteApp.drive(onNext: { [weak self] in
            self?.toMainTabs()
        }).disposed(by: rx.disposeBag)
        let viewController = TutorialViewControllerFactory.default(viewModel: viewModel)
        let navigationController = NavigationControllerFactory.new()
        navigationController.setViewControllers([viewController], animated: false)
        return navigationController
    }
    
    private func assemblyPlayers() -> UIViewController {
        let viewModel = PlayersViewModelFactory.default()
        let viewController = PlayersViewControllerFactory.withTabBarItem(viewModel: viewModel)
        let navigationController = NavigationControllerFactory.new()
        navigationController.setViewControllers([viewController], animated: false)
        return navigationController
    }
    
    private func assemblyTeams() -> UIViewController {
        let viewModel = TeamsViewModelFactory.default()
        let viewController = TeamsViewControllerFactory.withTabBarItem(viewModel: viewModel)
        let navigationController = NavigationControllerFactory.new()
        navigationController.setViewControllers([viewController], animated: false)
        return navigationController
    }
    
    private func assemblyEvents() -> UIViewController {
        let viewModel = EventsViewModelFactory.default()
        let viewController = EventsViewControllerFactory.withTabBarItem(viewModel: viewModel)
        let navigationController = NavigationControllerFactory.new()
        navigationController.setViewControllers([viewController], animated: false)
        return navigationController
    }
    
    private func assemblyNews() -> UIViewController {
        let viewModel = NewsViewModelFactory.default()
        let viewController = NewsViewControllerFactory.withTabBarItem(viewModel: viewModel)
        let navigationController = NavigationControllerFactory.new()
        navigationController.setViewControllers([viewController], animated: false)
        return navigationController
    }
    
    private func assemblyProfile() -> UIViewController {
        let viewModel = ProfileViewModelFactory.default()
        let viewController = ProfileViewControllerFactory.withTabBarItem(viewModel: viewModel)
        let navigationController = NavigationControllerFactory.new()
        navigationController.setViewControllers([viewController], animated: false)
        return navigationController
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
