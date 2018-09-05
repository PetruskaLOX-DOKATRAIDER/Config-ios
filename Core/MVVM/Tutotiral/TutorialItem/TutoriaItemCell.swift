//
//  TutoriaItemCell.swift
//  Core
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

final class TutoriaItemCell: UICollectionViewCell, ModelTransfer, ReusableViewProtocol {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var coverImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .bagdet
        
        titleLabel.font = .filsonMediumWithSize(17)
        titleLabel.textColor = .snowWhite
        
        descriptionLabel.font = .filsonRegularWithSize(15)
        descriptionLabel.textColor = .solled
    }
    
    func onUpdate(with viewModel: TutorialItemViewModel, disposeBag: DisposeBag) {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.description.drive(descriptionLabel.rx.text).disposed(by: disposeBag)
        viewModel.coverImage.drive(coverImageView.rx.image).disposed(by: disposeBag)
    }
}
