//
//  UIView+MessageView.swift
//  Core
//
//  Created by Oleg Petrychuk on 19.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension UIView {
    func showMessageView(withViewModel viewModel: MessageViewModel) {
        let messageView = MessageView(frame: bounds)
        messageView.viewModel = viewModel
        messageView.applyShadow()
        messageView.alpha = 0
        messageView.layer.zPosition = 101
        
        addSubview(messageView)
        messageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
