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
        delegate = self
        tabBar.tintColor = .ichigos
        tabBar.barTintColor = .tapped
        hidesBottomBarWhenPushed = true
    }
    
    //public func onUpdate(with viewModel: AppSectionsViewModel, disposeBag: DisposeBag) {}
}

extension AppSectionsTabBarController: UITabBarControllerDelegate  {
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else { return false }
        guard fromView != toView else { return true }
        UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        return true
    }
}
