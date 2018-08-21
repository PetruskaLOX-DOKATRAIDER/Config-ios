//
//  ProfileDetailItemCell.swift
//  Core
//
//  Created by Oleg Petrychuk on 21.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import DTModelStorage

final class ProfileDetailItemCell: UITableViewCell, ModelTransfer, ReusableViewProtocol {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = .solled
        titleLabel.font = .filsonMediumWithSize(18)
        titleLabel.text = Strings.Storage.title
    }
    
    public func onUpdate(with viewModel: ProfileDetailItemViewModel, disposeBag: DisposeBag) {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: disposeBag)
        //viewModel.withDetail.map{ !$0 }.drive(detailImageView.rx.isHidden).disposed(by: disposeBag)
        viewModel.icon.drive(iconImageView.rx.image).disposed(by: disposeBag)
    }
}
