//
//  EventItemCell.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public class EventItemCell: UITableViewCell, ReusableViewProtocol, ModelTransfer {
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = Colors.amethyst
        containerView.applyShadow(color: Colors.amethyst.cgColor)
        
        nameLabel.font = .filsonMediumWithSize(17)
        nameLabel.textColor = Colors.snowWhite
        
        cityLabel.font = .filsonRegularWithSize(17)
        cityLabel.textColor = Colors.solled
        
        descriptionLabel.font = .filsonRegularWithSize(30)
        descriptionLabel.textColor = Colors.solled
    }
    
    public func onUpdate(with viewModel: EventItemViewModel, disposeBag: DisposeBag) {
        func attributed(_ eventDescription: HighlightText) -> NSAttributedString {
            let attributedStr = NSMutableAttributedString(string: eventDescription.full)
            eventDescription.highlights.forEach {
                attributedStr.setColorForText(textForAttribute: $0, withColor: Colors.ichigos)
            }
            return attributedStr
        }
    
        viewModel.name.drive(nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.city.drive(cityLabel.rx.text).disposed(by: disposeBag)
        viewModel.flagURL.drive(flagImageView.rx.imageURL).disposed(by: disposeBag)
        viewModel.logoURL.drive(logoImageView.rx.imageURL).disposed(by: disposeBag)
        viewModel.description.map{ attributed($0) }.drive(descriptionLabel.rx.attributedText).disposed(by: disposeBag)
    }
}
