//
//  PlayersViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public class PlayersViewController: UIViewController, NonReusableViewProtocol {
    
    public func onUpdate(with viewModel: PlayersViewModel, disposeBag: DisposeBag) {

    }
}

// MARK: Factory

public class PlayersViewControllerFactory {
    public static func withTabBarItem(viewModel: PlayersViewModel = PlayersViewModelFactory.default()) -> UIViewController {
        let viewController = StoryboardScene.Players.initialViewController()
        viewController.tabBarItem = UITabBarItem(title: "qq", image: nil, selectedImage: nil)
        viewController.viewModel = viewModel
        return viewController
    }
}
