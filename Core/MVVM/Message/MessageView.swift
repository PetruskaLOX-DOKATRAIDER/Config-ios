//
//  MessageView.swift
//  Core
//
//  Created by Oleg Petrychuk on 21.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import LoadableViews

class MessageView: LoadableView, NonReusableViewProtocol, ViewModelHolderProtocol {
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet private weak var backgroundView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        iconImageView.tintColor = .ichigos
        titleLabel.textColor = .ichigos
        descriptionLabel.textColor = .ichigos
        backgroundView.backgroundColor = .black
        titleLabel.font = .filsonBoldWithSize(15)
        descriptionLabel.font = .filsonRegularWithSize(15)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onUpdate(with viewModel: MessageViewModel, disposeBag: DisposeBag) {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.description.drive(descriptionLabel.rx.text).disposed(by: disposeBag)
        viewModel.icon.drive(iconImageView.rx.image).disposed(by: disposeBag)
    }
}
