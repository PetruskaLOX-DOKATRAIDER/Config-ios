//
//  NavigationControllerFactory.swift
//  Core
//
//  Created by Oleg Petrychuk on 18.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public class NavigationControllerFactory {
    public static func new() -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = .red
        navigationController.navigationBar.titleColor(.blue)
        navigationController.navigationBar.barTintColor = .orange
        //navigationController.navigationBar.setTitleVerticalPositionAdjustment(9, for: .default)
        //navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.titleFont(UIFont.themeRegularWithSize(18))
        return navigationController
    }
}
