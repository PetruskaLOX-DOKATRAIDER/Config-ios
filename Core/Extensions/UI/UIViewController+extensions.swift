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
    
    func addChild(viewController: UIViewController, onContainer container: UIView) {
        self.addChildViewController(viewController)
        container.addSubview(viewController.view)
        viewController.view.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        viewController.didMove(toParentViewController: viewController)
    }
}
