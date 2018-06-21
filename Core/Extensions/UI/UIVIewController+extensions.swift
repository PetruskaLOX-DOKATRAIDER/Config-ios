//
//  UIVIewController+extensions.swift
//  Core
//
//  Created by Oleg Petrychuk on 21.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import SnapKit
import NVActivityIndicatorView

extension UIViewController {
    private var indicatorViewTag: Int { return 54534 }
    
    func showActivityIndicatorView(withColor color: UIColor = .ichigos) {
        guard findActivityIndicatorView() == nil else { return }
        let indicatorView = NVActivityIndicatorView(frame: .zero, type: .ballScaleMultiple, color: color)
        indicatorView.layer.zPosition = 101
        indicatorView.tag = indicatorViewTag
        view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.center.equalTo(view)
        }
        indicatorView.startAnimating()
    }
    
    func hideActivityIndicatorView() {
        guard let indicatorView = findActivityIndicatorView() else { return }
        indicatorView.stopAnimating()
        indicatorView.removeFromSuperview()
    }
    
    private func findActivityIndicatorView() -> NVActivityIndicatorView? {
        var activityIndicatorView: NVActivityIndicatorView? = nil
        view.subviews.forEach{ view in
            guard let indicator = view as? NVActivityIndicatorView, view.tag == indicatorViewTag else { return }
            activityIndicatorView = indicator
        }
        return activityIndicatorView
    }
}

extension UIViewController {
    func showMessageView(withViewModel viewModel: MessageViewModel) {
        let messageView = MessageView()
        messageView.viewModel = viewModel
        messageView.alpha = 0
        messageView.layer.zPosition = 101
        
        view.addSubview(messageView)
        messageView.snp.makeConstraints { make in
            make.bottom.equalTo(view).offset(-100)
            make.left.equalTo(view).offset(12)
            make.right.equalTo(view).offset(-12)
            make.bottom.equalTo(messageView.descriptionLabel.snp.bottom).offset(8)
        }
        
        UIView.animate(withDuration: 0.4, animations: {
            messageView.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.4, delay: 3, options: .curveEaseOut, animations: {
                messageView.alpha = 0
            }, completion: { _ in
                messageView.removeFromSuperview()
            })
        })
    }
}
