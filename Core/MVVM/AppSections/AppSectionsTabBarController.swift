//
//  AppSectionsTabBarController.swift
//  Core
//
//  Created by Oleg Petrychuk on 25.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// Need TabBar with empty VM for using it on Router

public final class AppSectionsTabBarController: UITabBarController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .ichigos
        tabBar.barTintColor = .tapped
        hidesBottomBarWhenPushed = true
    }
    
    //public func onUpdate(with viewModel: AppSectionsViewModel, disposeBag: DisposeBag) {}
}
