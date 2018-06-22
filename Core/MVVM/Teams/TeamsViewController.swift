//
//  TeamsViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

class TeamsViewController: UIViewController, NonReusableViewProtocol {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.Teams.title
        view.backgroundColor = .bagdet
    }
    
    func onUpdate(with viewModel: TeamsViewModel, disposeBag: DisposeBag) {

    }
}

// MARK: Factory

public class TeamsViewControllerFactory {
    public static func withTabBarItem(
        viewModel: TeamsViewModel = TeamsViewModelFactory.default()
    ) -> UIViewController {
        let viewController = StoryboardScene.Teams.initialViewController()
        viewController.tabBarItem = TabBarItemFactory.new(
            title: Strings.Teams.title,
            image: Images.Sections.teamsDeselected,
            selectedImage: Images.Sections.teamsSelected
        )
        viewController.viewModel = viewModel
        return viewController
    }
}
