//
//  UIView+MessageView.swift
//  Core
//
//  Created by Oleg Petrychuk on 19.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension UIView {
    func showMessageView(withViewModel viewModel: MessageViewModel) {
        let messageView = MessageView()
        messageView.viewModel = viewModel
        messageView.alpha = 0
        messageView.layer.zPosition = 101
        
        addSubview(messageView)
        messageView.snp.makeConstraints {
            $0.bottom.equalTo(self).offset(-100)
            $0.left.equalTo(self).offset(12)
            $0.right.equalTo(self).offset(-12)
            $0.bottom.equalTo(messageView.descriptionLabel.snp.bottom).offset(8)
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
