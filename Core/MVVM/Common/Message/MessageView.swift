//
//  MessageView.swift
//  Core
//
//  Created by Oleg Petrychuk on 21.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

final class MessageView: LoadableView, NonReusableViewProtocol {
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func setupNib() {
        super.setupNib()
        
        iconImageView.tintColor = Colors.ichigos
        containerView.backgroundColor = Colors.amethyst
        
        titleLabel.textColor = Colors.ichigos
        titleLabel.font = .filsonBoldWithSize(15)
        
        descriptionLabel.textColor = Colors.solled
        descriptionLabel.font = .filsonRegularWithSize(15)
    }
    
    func onUpdate(with viewModel: MessageViewModel, disposeBag: DisposeBag) {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.description.drive(descriptionLabel.rx.text).disposed(by: disposeBag)
        viewModel.icon.drive(iconImageView.rx.image).disposed(by: disposeBag)
    }
}
