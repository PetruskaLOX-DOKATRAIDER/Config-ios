//
//  EventsViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class EventsViewController: UIViewController, NonReusableViewProtocol {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.Events.title
        view.backgroundColor = .bagdet
        tabBarItem = TabBarItemFactory.new(
            title: Strings.Events.title,
            image: Images.Sections.eventsDeselected,
            selectedImage: Images.Sections.eventsSelected
        )
    }
    
    public func onUpdate(with viewModel: EventsViewModel, disposeBag: DisposeBag) {

    }
}
