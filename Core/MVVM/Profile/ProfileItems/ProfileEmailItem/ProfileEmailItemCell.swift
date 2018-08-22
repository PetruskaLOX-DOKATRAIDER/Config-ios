//
//  ProfileEmailItemCell.swift
//  Core
//
//  Created by Oleg Petrychuk on 21.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import DTModelStorage

final class ProfileEmailItemCell: UITableViewCell, ModelTransfer, ReusableViewProtocol {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var saveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .amethyst
        
        titleLabel.textColor = .solled
        titleLabel.font = .filsonMediumWithSize(18)
        titleLabel.text = Strings.Profileemail.title
        
        descriptionLabel.textColor = .solled
        descriptionLabel.font = .filsonRegularWithSize(15)
        descriptionLabel.text = Strings.Profileemail.description
        
        saveButton.setTitle(Strings.Profileemail.save, for: .normal)
        saveButton.setTitleColor(.snowWhite, for: .normal)
        saveButton.backgroundColor = .ichigos
        saveButton.titleLabel?.font = .filsonMediumWithSize(14)
    }
    
    public func onUpdate(with viewModel: ProfileEmailItemViewModel, disposeBag: DisposeBag) {
        emailTextField.viewModel = viewModel.emailVM
        saveButton.rx.tap.bind(to: viewModel.saveTrigger).disposed(by: disposeBag)
    }
    
    public static func defaultHeight() -> CGFloat {
        return 165
    }
}
