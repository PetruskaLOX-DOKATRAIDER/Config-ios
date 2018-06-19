//
//  TeamsViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public class TeamsViewController: UIViewController, NonReusableViewProtocol {
    public func onUpdate(with viewModel: TeamsViewModel, disposeBag: DisposeBag) {

    }
}

// MARK: Factory

public class TeamsViewControllerFactory {
    public static func withTabBarItem(viewModel: TeamsViewModel = TeamsViewModelFactory.default()) -> UIViewController {
        let viewController = StoryboardScene.Teams.initialViewController()
        viewController.tabBarItem = UITabBarItem(title: "qq", image: nil, selectedImage: nil)
        viewController.viewModel = viewModel
        return viewController
    }
}
