//
//  NewsViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public class NewsViewController: UIViewController, NonReusableViewProtocol {
    public func onUpdate(with viewModel: NewsViewModel, disposeBag: DisposeBag) {

    }
}

// MARK: Factory

public class NewsViewControllerFactory {
    public static func withTabBarItem(viewModel: NewsViewModel = NewsViewModelFactory.default()) -> UIViewController {
        let viewController = StoryboardScene.News.initialViewController()
        viewController.tabBarItem = UITabBarItem(title: "qq", image: nil, selectedImage: nil)
        viewController.viewModel = viewModel
        return viewController
    }
}
