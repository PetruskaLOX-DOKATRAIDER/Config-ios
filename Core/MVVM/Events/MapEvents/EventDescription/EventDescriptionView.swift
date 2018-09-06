//
//  EventDescriptionView.swift
//  Core
//
//  Created by Oleg Petrychuk on 24.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

final class EventDescriptionView: LoadableView, NonReusableViewProtocol {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var detailsButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        nameLabel.font = .filsonMediumWithSize(17)
        nameLabel.textColor = .snowWhite
        
        cityLabel.font = .filsonRegularWithSize(17)
        cityLabel.textColor = .solled
        
        detailsButton.applyShadow()
        detailsButton.backgroundColor = .ichigos
        detailsButton.setTitleColor(.snowWhite, for: .normal)
        detailsButton.titleLabel?.font = .filsonMediumWithSize(17)
        detailsButton.setTitle(Strings.EventDescription.details, for: .normal)
    }
    
    func onUpdate(with viewModel: EventDescriptionViewModel, disposeBag: DisposeBag) {
        viewModel.name.drive(nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.city.drive(cityLabel.rx.text).disposed(by: disposeBag)
        viewModel.flagURL.drive(flagImageView.rx.imageURL).disposed(by: disposeBag)
        viewModel.logoURL.drive(logoImageView.rx.imageURL).disposed(by: disposeBag)
        detailsButton.rx.tap.bind(to: viewModel.detailsTrigger).disposed(by: disposeBag)
        shareButton.rx.tap.bind(to: viewModel.shareTrigger).disposed(by: disposeBag)
    }
}
