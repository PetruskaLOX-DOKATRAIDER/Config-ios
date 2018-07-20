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
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func onUpdate(with viewModel: EventItemViewModel, disposeBag: DisposeBag) {
        viewModel.name.drive(nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.city.drive(cityLabel.rx.text).disposed(by: disposeBag)
        viewModel.flagURL.drive(flagImageView.rx.imageURL).disposed(by: disposeBag)
        viewModel.logoURL.drive(logoImageView.rx.imageURL).disposed(by: disposeBag)
        viewModel.description.drive(onNext: { [weak self] description in
            self?.descriptionLabel.text = description.fullText
        }).disposed(by: disposeBag)
    }
}
