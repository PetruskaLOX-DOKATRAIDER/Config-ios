//
//  UIFont+extensions.swift
//  Core
//
//  Created by Oleg Petrychuk on 18.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension UIFont {
    static func themeRegularWithSize(_ size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "FilsonSoftRegular", size: size) else { fatalError("Can't find FilsonSoftRegular font") }
        return font
    }
    
    static func themeBoldWithSize(_ size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "FilsonSoft-Bold", size: size) else { fatalError("Can't find FilsonSoft-Bold font") }
        return font
    }
    
    static func themeLightWithSize(_ size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "FilsonSoft-Light", size: size) else { fatalError("Can't find FilsonSoft-Light font") }
        return font
    }
    
    static func themeMediumWithSize(_ size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "FilsonSoftMedium", size: size) else { fatalError("Can't find FilsonSoftMedium font") }
        return font
    }
}
