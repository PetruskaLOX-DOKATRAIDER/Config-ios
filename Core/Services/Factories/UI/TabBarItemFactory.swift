//
//  TabBarItemFactory.swift
//  Core
//
//  Created by Oleg Petrychuk on 21.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public class TabBarItemFactory {
    public static func new(
        title: String,
        image: UIImage,
        selectedImage: UIImage
    ) -> UITabBarItem {
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        tabBarItem.setTitleTextAttributes([.font : UIFont.filsonRegularWithSize(12)], for: .normal)
        tabBarItem.setTitleTextAttributes([.font : UIFont.filsonRegularWithSize(12)], for: .selected)
        return tabBarItem
    }
}
