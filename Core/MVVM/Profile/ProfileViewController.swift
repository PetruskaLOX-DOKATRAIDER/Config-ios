//
//  ProfileViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class ProfileViewController: UIViewController, NonReusableViewProtocol {
   
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.Profile.title
        view.backgroundColor = .bagdet
        tabBarItem = TabBarItemFactory.new(
            title: Strings.Profile.title,
            image: Images.Sections.profileDeselected,
            selectedImage: Images.Sections.profileSelected
        )
    }
    
    public func onUpdate(with viewModel: ProfileViewModel, disposeBag: DisposeBag) {

    }
}
