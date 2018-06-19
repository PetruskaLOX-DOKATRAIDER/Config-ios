//
//  TutoriaItemCell.swift
//  Core
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import DTModelStorage

class TutoriaItemCell: UICollectionViewCell, ReusableViewProtocol, ModelTransfer {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var coverImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = .filsonMediumWithSize(17)
        titleLabel.textColor = .amethyst
        descriptionLabel.font = .filsonRegularWithSize(15)
        descriptionLabel.textColor = .laded
    }
    
    public func onUpdate(with viewModel: TutorialItemViewModel, disposeBag: DisposeBag) {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.description.drive(descriptionLabel.rx.text).disposed(by: disposeBag)
        viewModel.coverImage.drive(coverImageView.rx.image).disposed(by: disposeBag)
    }
}
