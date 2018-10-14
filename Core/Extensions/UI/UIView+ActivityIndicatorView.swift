//
//  UIView+ActivityIndicatorView.swift
//  Core
//
//  Created by Oleg Petrychuk on 19.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import NVActivityIndicatorView

extension UIView {
    private var indicatorViewTag: Int { return 54534 }
    
    func showActivityIndicatorView(withColor color: UIColor = .ichigos) {
        guard findActivityIndicatorView() == nil else { return }
        let indicatorView = NVActivityIndicatorView(frame: .zero, type: .ballScaleMultiple, color: color)
        indicatorView.layer.zPosition = 101
        indicatorView.tag = indicatorViewTag
        addSubview(indicatorView)
        indicatorView.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.center.equalTo(self)
        }
        indicatorView.startAnimating()
    }
    
    func hideActivityIndicatorView() {
        guard let indicatorView = findActivityIndicatorView() else { return }
        indicatorView.stopAnimating()
        indicatorView.removeFromSuperview()
    }
    
    private func findActivityIndicatorView() -> NVActivityIndicatorView? {
        var activityIndicatorView: NVActivityIndicatorView?
        subviews.forEach{ view in
            guard let indicator = view as? NVActivityIndicatorView, view.tag == indicatorViewTag else { return }
            activityIndicatorView = indicator
        }
        return activityIndicatorView
    }
}
