//
//  NewsItemCell.swift
//  Config
//
//  Created by Oleg Petrychuk on 31.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

final class NewsItemCell: UICollectionViewCell, ModelTransfer, ReusableViewProtocol {
    @IBOutlet private weak var gradeintView: GradientView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var shareButton: UIButton!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = .ichigos
        containerView.applyShadow(color: UIColor.amethyst.cgColor)

        titleLabel.textColor = .snowWhite
        titleLabel.font = .filsonMediumWithSize(23)

        gradeintView.startColor = .clear
        gradeintView.endColor = .ichigos
    }
    
    public func onUpdate(with viewModel: NewsItemViewModel, disposeBag: DisposeBag) {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.coverImage.drive(coverImageView.rx.imageURL).disposed(by: disposeBag)
        shareButton.rx.tap.bind(to: viewModel.shareTrigger).disposed(by: disposeBag)
    }
}
