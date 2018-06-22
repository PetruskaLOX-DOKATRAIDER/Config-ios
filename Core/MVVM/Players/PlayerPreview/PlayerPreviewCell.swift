//
//  PlayerPreviewCell.swift
//  Core
//
//  Created by Oleg Petrychuk on 22.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import DTModelStorage

class PlayerPreviewCell: UICollectionViewCell, ReusableViewProtocol, ModelTransfer {
    @IBOutlet private weak var nicknameLabel: UILabel!
    @IBOutlet private weak var profileImageView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nicknameLabel.font = .filsonMediumWithSize(17)
        nicknameLabel.textColor = .amethyst
    }
    
    public func onUpdate(with viewModel: PlayerPreviewViewModel, disposeBag: DisposeBag) {
        viewModel.nickname.drive(nicknameLabel.rx.text).disposed(by: disposeBag)
    }
}
