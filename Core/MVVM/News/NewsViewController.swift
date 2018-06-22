//
//  NewsViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

final class NewsViewController: UIViewController, NonReusableViewProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.News.title
        view.backgroundColor = .bagdet
    }
    
    func onUpdate(with viewModel: NewsViewModel, disposeBag: DisposeBag) {

    }
}

// MARK: Factory

public class NewsViewControllerFactory {
    public static func withTabBarItem(
        viewModel: NewsViewModel = NewsViewModelFactory.default()
    ) -> UIViewController {
        let viewController = StoryboardScene.News.initialViewController()
        viewController.tabBarItem = TabBarItemFactory.new(
            title: Strings.News.title,
            image: Images.Sections.newsDeselected,
            selectedImage: Images.Sections.newsSelected
        )
        viewController.viewModel = viewModel
        return viewController
    }
}
