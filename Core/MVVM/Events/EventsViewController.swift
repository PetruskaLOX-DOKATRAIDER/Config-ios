//
//  EventsViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public class EventsViewController: UIViewController, NonReusableViewProtocol {
    public func onUpdate(with viewModel: EventsViewModel, disposeBag: DisposeBag) {

    }
}

// MARK: Factory

public class EventsViewControllerFactory {
    public static func withTabBarItem(viewModel: EventsViewModel = EventsViewModelFactory.default()) -> UIViewController {
        let viewController = StoryboardScene.Events.initialViewController()
        viewController.tabBarItem = UITabBarItem(title: "qq", image: nil, selectedImage: nil)
        viewController.viewModel = viewModel
        return viewController
    }
}
