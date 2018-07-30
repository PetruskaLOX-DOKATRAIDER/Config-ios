//
//  NavigationControllerFactory.swift
//  Core
//
//  Created by Oleg Petrychuk on 18.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public class NavigationControllerFactory {
    public static func `default`(viewControllers: [UIViewController] = []) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.setViewControllers(viewControllers, animated: false)
        navigationController.navigationBar.titleColor(.ichigos)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.titleFont(UIFont.filsonRegularWithSize(18))
        navigationController.navigationBar.barTintColor = .navos
        if #available(iOS 11.0, *) {
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.navigationBar.largeTitleFont(.filsonRegularWithSize(30))
            navigationController.navigationBar.largeTitleColor(.ichigos)
        }
        return navigationController
    }
    
    public static func clear(viewControllers: [UIViewController] = []) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.setViewControllers(viewControllers, animated: false)
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.titleFont(.filsonMediumWithSize(19))
        navigationController.navigationBar.titleColor(.snowWhite)
        if #available(iOS 11.0, *) {
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.navigationBar.largeTitleFont(.filsonMediumWithSize(30))
            navigationController.navigationBar.largeTitleColor(.snowWhite)
        }
        return navigationController
    }
}

extension UINavigationController  {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
