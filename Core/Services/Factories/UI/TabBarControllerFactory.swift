//
//  TabBarControllerFactory.swift
//  Core
//
//  Created by Oleg Petrychuk on 21.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public class TabBarControllerFactory {
    public static func new(withViewControllers viewControllers: [UIViewController]) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .ichigos
        tabBarController.tabBar.barTintColor = .tapped
        tabBarController.setViewControllers(viewControllers, animated: false)
        return tabBarController
    }
}
