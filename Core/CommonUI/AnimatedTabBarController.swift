//
//  AnimatedTabBarController.swift
//  Core
//
//  Created by Oleg Petrychuk on 04.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class AnimatedTabBarController: UITabBarController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        tabBar.tintColor = Colors.ichigos
        tabBar.barTintColor = Colors.tapped
        hidesBottomBarWhenPushed = true
    }
}

extension AnimatedTabBarController: UITabBarControllerDelegate  {
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else { return false }
        guard fromView != toView else { return true }
        UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        return true
    }
}
