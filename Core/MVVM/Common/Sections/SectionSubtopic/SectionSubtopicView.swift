//
//  SectionSubtopicView.swift
//  Core
//
//  Created by Oleg Petrychuk on 22.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

final class SectionSubtopicView: UITableViewHeaderFooterView, ModelTransfer, ReusableViewProtocol {
    @IBOutlet private weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.textColor = Colors.quaded
        messageLabel.font = .filsonMediumWithSize(15)
    }
    
    func onUpdate(with viewModel: SectionSubtopicViewModel, disposeBag: DisposeBag) {
        viewModel.message.drive(messageLabel.rx.text).disposed(by: disposeBag)
    }
}
