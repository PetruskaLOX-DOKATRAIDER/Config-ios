//
//  AppAppearence.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//


public enum AppAppearence {
    static public func style() {
        
    }
    
    static public func controllerSpecific() -> Disposable {
        return Disposables.create {}
    }
}

extension UINavigationController {
    override open var preferredStatusBarStyle: UIStatusBarStyle { return .default }
}
