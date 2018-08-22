//
//  SectionSubtopicView.swift
//  Core
//
//  Created by Oleg Petrychuk on 22.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import DTModelStorage

class SectionSubtopicView: UITableViewHeaderFooterView, ModelTransfer, ReusableViewProtocol {
    @IBOutlet private weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .amethyst
        
        messageLabel.textColor = .quaded
        messageLabel.font = .filsonMediumWithSize(15)
    }
    
    public func onUpdate(with viewModel: SectionSubtopicViewModel, disposeBag: DisposeBag) {
        viewModel.message.drive(messageLabel.rx.text).disposed(by: disposeBag)
    }
}
