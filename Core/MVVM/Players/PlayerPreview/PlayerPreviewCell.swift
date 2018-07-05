//
//  PlayerPreviewCell.swift
//  Core
//
//  Created by Oleg Petrychuk on 22.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import DTModelStorage

public class PlayerPreviewCell: UICollectionViewCell, ReusableViewProtocol, ModelTransfer {
    public static let nickNameContainerHeight: CGFloat = 40
    @IBOutlet private weak var nicknameLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        nicknameLabel.font = .filsonMediumWithSize(17)
        nicknameLabel.textColor = .snowWhite
        contentView.backgroundColor = .ichigos
    }
    
    public func onUpdate(with viewModel: PlayerPreviewViewModel, disposeBag: DisposeBag) {
        viewModel.nickname.drive(nicknameLabel.rx.text).disposed(by: disposeBag)
        viewModel.avatarURL.drive(avatarImageView.rx.imageURL).disposed(by: disposeBag)
    }
}
