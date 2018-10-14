//
//  SkinItemCell.swift
//  Core
//
//  Created by Oleg Petrychuk on 23.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

class SkinItemCell: UITableViewCell, ReusableViewProtocol, ModelTransfer {
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = Colors.amethyst
        containerView.applyShadow(color: Colors.amethyst.cgColor)
        
        titleLabel.font = .filsonMediumWithSize(17)
        titleLabel.textColor = Colors.snowWhite
        
        descriptionLabel.font = .filsonRegularWithSize(17)
        descriptionLabel.textColor = Colors.solled
    }
    
    func onUpdate(with viewModel: SkinItemViewModel, disposeBag: DisposeBag) {
        func attributed(_ eventDescription: HighlightText) -> NSAttributedString {
            let attributedStr = NSMutableAttributedString(string: eventDescription.full)
            eventDescription.highlights.forEach {
                attributedStr.setColorForText(textForAttribute: $0, withColor: Colors.ichigos)
            }
            return attributedStr
        }
        
        viewModel.title.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.coverImageURL.drive(coverImageView.rx.imageURL).disposed(by: disposeBag)
        viewModel.description.map{ attributed($0) }.drive(descriptionLabel.rx.attributedText).disposed(by: disposeBag)
    }
}
