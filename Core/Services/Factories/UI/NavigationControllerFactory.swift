//
//  NavigationControllerFactory.swift
//  Core
//
//  Created by Oleg Petrychuk on 18.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

final class NavigationControllerFactory {
    static func `default`(viewControllers: [UIViewController] = []) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.setViewControllers(viewControllers, animated: false)
        navigationController.navigationBar.titleColor(Colors.ichigos)
        navigationController.navigationBar.titleFont(.filsonRegularWithSize(18))
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.barTintColor = Colors.tapped
        if #available(iOS 11.0, *) {
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.navigationBar.largeTitleFont(.filsonRegularWithSize(30))
            navigationController.navigationBar.largeTitleColor(Colors.ichigos)
        }
        return navigationController
    }
    
    static func clear(viewControllers: [UIViewController] = []) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.setViewControllers(viewControllers, animated: false)
        navigationController.navigationBar.titleColor(Colors.snowWhite)
        navigationController.navigationBar.titleFont(.filsonMediumWithSize(19))
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .`default`)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        return navigationController
    }
}

extension UINavigationController  {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
