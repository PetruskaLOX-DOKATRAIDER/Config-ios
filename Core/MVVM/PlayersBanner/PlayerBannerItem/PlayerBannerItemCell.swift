//
//  PlayerBannerItemCell.swift
//  Core
//
//  Created by Oleg Petrychuk on 16.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

final class PlayerBannerItemCell: UICollectionViewCell, ReusableViewProtocol, ModelTransfer {
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = .filsonRegularWithSize(14)
        titleLabel.textColor = Colors.snowWhite
    }
    
    public func onUpdate(with viewModel: PlayerBannerItemViewModel, disposeBag: DisposeBag) {
        viewModel.coverImageURL.drive(coverImageView.rx.imageURL).disposed(by: disposeBag)
        viewModel.title.drive(titleLabel.rx.text).disposed(by: disposeBag)
    }
}
