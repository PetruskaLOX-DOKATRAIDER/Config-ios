//
//  TeamsViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public class TeamsViewController: UIViewController, NonReusableViewProtocol {
   
    override public func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.Teams.title
        view.backgroundColor = .bagdet
        tabBarItem = TabBarItemFactory.new(
            title: Strings.Teams.title,
            image: Images.Sections.teamsDeselected,
            selectedImage: Images.Sections.teamsSelected
        )
    }
    
    public func onUpdate(with viewModel: TeamsViewModel, disposeBag: DisposeBag) {

    }
}
