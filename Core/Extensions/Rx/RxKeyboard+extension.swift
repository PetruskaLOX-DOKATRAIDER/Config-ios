//
//  RxKeyboard+extension.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import RxKeyboard

enum KeyboardAvoiding {
    static func avoid(with bottom: NSLayoutConstraint?, inside view: UIView?) -> Disposable {
        return RxKeyboard.instance.visibleHeight.drive(onNext: { [weak bottom, weak view] in
            bottom?.constant = $0
            view?.setNeedsLayout()
            UIView.animate(withDuration: 0) {
                view?.layoutIfNeeded()
            }
        })
    }
    
    static func avoid(with scrollView: UIScrollView?, inside view: UIView?) -> Disposable {
        return RxKeyboard.instance.frame.drive(onNext: { [scrollView, weak view] frame in
            if let view = view, let scrollView = scrollView, let window = UIApplication.shared.keyWindow {
                var keyboardOverlap = max(0, window.frame.maxY - frame.origin.y)
                if #available(iOS 11, *), keyboardOverlap > 0 {
                    keyboardOverlap -= view.safeAreaInsets.bottom
                }
                scrollView.contentInset.bottom = keyboardOverlap
                scrollView.scrollIndicatorInsets.bottom = keyboardOverlap
            }
        })
    }
}
