//
//  NewsItemCell.swift
//  Config
//
//  Created by Oleg Petrychuk on 31.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import DTModelStorage

public class NewsItemCell: UICollectionViewCell, ModelTransfer, ReusableViewProtocol {
    @IBOutlet weak var gradeintView: GradientView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .bagdet
        contentView.applyShadow()
        
        titleLabel.textColor = .snowWhite
        titleLabel.font = .filsonMediumWithSize(17)
        
        gradeintView.startColor = .ichigos
        gradeintView.endColor = .clear
    }
    
    public func onUpdate(with viewModel: NewsItemViewModel, disposeBag: DisposeBag) {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.coverImage.drive(coverImageView.rx.imageURL).disposed(by: disposeBag)
    }
}
