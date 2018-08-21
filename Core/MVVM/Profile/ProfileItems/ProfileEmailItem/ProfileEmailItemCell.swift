//
//  ProfileEmailItemCell.swift
//  Core
//
//  Created by Oleg Petrychuk on 21.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import DTModelStorage

final class ProfileEmailItemCell: UITableViewCell, ModelTransfer, ReusableViewProtocol {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = .solled
        titleLabel.font = .filsonMediumWithSize(18)
        titleLabel.text = Strings.Storage.title
        
        descriptionLabel.textColor = .solled
        descriptionLabel.font = .filsonRegularWithSize(15)
        descriptionLabel.text = Strings.Storage.warning
    }
    
    public func onUpdate(with viewModel: ProfileEmailItemViewModel, disposeBag: DisposeBag) {
        emailTextField.viewModel = viewModel.emailVM
    }
}
