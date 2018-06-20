//
//  ProfileViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public class ProfileViewController: UIViewController, NonReusableViewProtocol {
    public func onUpdate(with viewModel: ProfileViewModel, disposeBag: DisposeBag) {

    }
}

// MARK: Factory

public class ProfileViewControllerFactory {
    public static func withTabBarItem(viewModel: ProfileViewModel = ProfileViewModelFactory.default()) -> UIViewController {
        let viewController = StoryboardScene.Profile.initialViewController()
        viewController.tabBarItem = UITabBarItem(title: "qq4", image: nil, selectedImage: nil)
        viewController.viewModel = viewModel
        return viewController
    }
}
