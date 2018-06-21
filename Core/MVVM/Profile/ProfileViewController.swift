//
//  ProfileViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

class ProfileViewController: UIViewController, NonReusableViewProtocol {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.Profile.title
        view.backgroundColor = .bagdet
    }
    
    func onUpdate(with viewModel: ProfileViewModel, disposeBag: DisposeBag) {

    }
}

// MARK: Factory

public class ProfileViewControllerFactory {
    public static func withTabBarItem(viewModel: ProfileViewModel = ProfileViewModelFactory.default()) -> UIViewController {
        let viewController = StoryboardScene.Profile.initialViewController()
        viewController.tabBarItem = TabBarItemFactory.new(
            title: Strings.Profile.title,
            image: Images.Sections.profileDeselected,
            selectedImage: Images.Sections.profileSelected
        )
        viewController.viewModel = viewModel
        return viewController
    }
}
