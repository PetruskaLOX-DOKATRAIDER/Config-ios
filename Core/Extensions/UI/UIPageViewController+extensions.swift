//
//  UIPageViewController+extensions.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension UIPageViewController {
    func setScrollEnabled(_ enabled: Bool) {
        view.subviews.forEach {
            guard let scrollView = $0 as? UIScrollView else { return }
            scrollView.isScrollEnabled = enabled
        }
    }
}
