//
//  PlayerPreviewCell.swift
//  Core
//
//  Created by Oleg Petrychuk on 22.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

final class PlayerPreviewCell: UICollectionViewCell, ModelTransfer, ReusableViewProtocol {
    @IBOutlet private weak var nicknameLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!
    public static let nicknameContainerHeight: CGFloat = 40
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        nicknameLabel.font = .filsonMediumWithSize(17)
        nicknameLabel.textColor = .snowWhite
        contentView.backgroundColor = .ichigos
    }
    
    func onUpdate(with viewModel: PlayerPreviewViewModel, disposeBag: DisposeBag) {
        viewModel.nickname.drive(nicknameLabel.rx.text).disposed(by: disposeBag)
        viewModel.avatarURL.drive(avatarImageView.rx.imageURL).disposed(by: disposeBag)
    }
}
