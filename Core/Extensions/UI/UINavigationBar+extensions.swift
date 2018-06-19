//
//  UINavigationBar+extensions.swift
//  Core
//
//  Created by Oleg Petrychuk on 18.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension UINavigationBar {
    @available(iOS 11.0, *)
    func largeTitleFont(_ font: UIFont) {
        if var attributes = largeTitleTextAttributes {
            attributes[NSAttributedStringKey.font] = font
            largeTitleTextAttributes = attributes
        } else {
            largeTitleTextAttributes = [NSAttributedStringKey.font: font]
        }
    }
    
    func titleFont(_ font: UIFont) {
        if var attributes = titleTextAttributes {
            attributes[NSAttributedStringKey.font] = font
            titleTextAttributes = attributes
        } else {
            titleTextAttributes = [NSAttributedStringKey.font: font]
        }
    }
    
    @available(iOS 11.0, *)
    func largeTitleColor(_ color: UIColor) {
        if var attributes = largeTitleTextAttributes {
            attributes[NSAttributedStringKey.foregroundColor] = color
            largeTitleTextAttributes = attributes
        } else {
            largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: color]
        }
    }
    
    func titleColor(_ color: UIColor) {
        if var attributes = titleTextAttributes {
            attributes[NSAttributedStringKey.foregroundColor] = color
            titleTextAttributes = attributes
        } else {
            titleTextAttributes = [NSAttributedStringKey.foregroundColor: color]
        }
    }
}
