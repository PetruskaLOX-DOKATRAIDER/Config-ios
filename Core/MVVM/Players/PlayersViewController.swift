//
//  PlayersViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

class PlayersViewController: UIViewController, NonReusableViewProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.Players.title
        view.backgroundColor = .bagdet
    }
    
    func onUpdate(with viewModel: PlayersViewModel, disposeBag: DisposeBag) {

    }
}

// MARK: Factory

public class PlayersViewControllerFactory {
    public static func withTabBarItem(viewModel: PlayersViewModel = PlayersViewModelFactory.default()) -> UIViewController {
        let viewController = StoryboardScene.Players.initialViewController()
        viewController.tabBarItem = TabBarItemFactory.new(
            title: Strings.Players.title,
            image: Images.Sections.playersDeselected,
            selectedImage: Images.Sections.playersSelected
        )
        viewController.viewModel = viewModel
        return viewController
    }
}
