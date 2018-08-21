//
//  ProfileViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import DTTableViewManager

public final class ProfileViewController: UIViewController, NonReusableViewProtocol, DTTableViewManageable {
    @IBOutlet public weak var tableView: UITableView!
    @IBOutlet private weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.Profile.title
        view.backgroundColor = .bagdet
        tabBarItem = TabBarItemFactory.new(
            title: Strings.Profile.title,
            image: Images.Sections.profileDeselected,
            selectedImage: Images.Sections.profileSelected
        )
        
        KeyboardAvoiding.avoid(with: tableViewBottomConstraint, inside: view).disposed(by: rx.disposeBag)
    }
    
    public func onUpdate(with viewModel: ProfileViewModel, disposeBag: DisposeBag) {
        
    }

}

