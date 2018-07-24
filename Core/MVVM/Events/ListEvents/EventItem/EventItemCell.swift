//
//  EventItemCell.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import DTModelStorage

public class EventItemCell: UITableViewCell, ReusableViewProtocol, ModelTransfer {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var colorContainerView: UIView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        colorContainerView.backgroundColor = .amethyst
        
        nameLabel.font = .filsonMediumWithSize(17)
        nameLabel.textColor = .snowWhite
        
        cityLabel.font = .filsonRegularWithSize(17)
        cityLabel.textColor = .solled
        
        descriptionLabel.font = .filsonRegularWithSize(30)
        descriptionLabel.textColor = .solled
        
        colorContainerView.applyShadow(color: UIColor.solled.cgColor)
    }
    
    public func onUpdate(with viewModel: EventItemViewModel, disposeBag: DisposeBag) {
        func descriptionAttributedString(_ eventDescription: EventDescription) -> NSAttributedString {
            let attributedStr = NSMutableAttributedString(string: eventDescription.fullText)
            attributedStr.setColorForText(textForAttribute: eventDescription.finishDateStr, withColor: .ichigos)
            attributedStr.setColorForText(textForAttribute: eventDescription.startDateStr, withColor: .ichigos)
            attributedStr.setColorForText(textForAttribute: eventDescription.countOfTeams, withColor: .ichigos)
            attributedStr.setColorForText(textForAttribute: eventDescription.prizePool, withColor: .ichigos)
            return attributedStr
        }
    
        viewModel.name.drive(nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.city.drive(cityLabel.rx.text).disposed(by: disposeBag)
        viewModel.flagURL.drive(flagImageView.rx.imageURL).disposed(by: disposeBag)
        viewModel.logoURL.drive(logoImageView.rx.imageURL).disposed(by: disposeBag)
        viewModel.description.map{ descriptionAttributedString($0) }.drive(descriptionLabel.rx.attributedText).disposed(by: disposeBag)
    }
}
