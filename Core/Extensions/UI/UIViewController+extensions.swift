//
//  UIViewController+extensions.swift
//  Core
//
//  Created by Oleg Petrychuk on 31.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension UIViewController {
    func addMotionTransition(_ transition: MotionTransitionAnimationType = .auto) {
        isMotionEnabled = true
        motionTransitionType = transition
    }
}
