//
//  EventsViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

class EventsViewController: UIViewController, NonReusableViewProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.Events.title
        view.backgroundColor = .bagdet
    }
    
    func onUpdate(with viewModel: EventsViewModel, disposeBag: DisposeBag) {

    }
}

// MARK: Factory

public class EventsViewControllerFactory {
    public static func withTabBarItem(
        viewModel: EventsViewModel = EventsViewModelFactory.default()
    ) -> UIViewController {
        let viewController = StoryboardScene.Events.initialViewController()
        viewController.tabBarItem = TabBarItemFactory.new(
            title: Strings.Events.title,
            image: Images.Sections.eventsDeselected,
            selectedImage: Images.Sections.eventsSelected
        )
        viewController.viewModel = viewModel
        return viewController
    }
}
