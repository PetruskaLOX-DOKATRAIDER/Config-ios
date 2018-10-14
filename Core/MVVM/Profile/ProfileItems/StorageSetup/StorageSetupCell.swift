//
//  StorageSetupCell.swift
//  Core
//
//  Created by Oleg Petrychuk on 21.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

final class StorageSetupCell: UITableViewCell, ModelTransfer, ReusableViewProtocol {
    @IBOutlet private weak var clearButton: UIButton!
    @IBOutlet private weak var warningLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Colors.amethyst
        
        titleLabel.textColor = Colors.solled
        titleLabel.font = .filsonMediumWithSize(18)
        titleLabel.text = Strings.Storage.title
        
        warningLabel.textColor = Colors.solled
        warningLabel.font = .filsonRegularWithSize(15)
        warningLabel.text = Strings.Storage.warning
        
        clearButton.setTitle(Strings.Storage.clear, for: .normal)
        clearButton.setTitleColor(Colors.snowWhite, for: .normal)
        clearButton.backgroundColor = Colors.ichigos
        clearButton.titleLabel?.font = .filsonMediumWithSize(16)
    }
    
    func onUpdate(with viewModel: StorageSetupViewModel, disposeBag: DisposeBag) {
        clearButton.rx.tap.bind(to: viewModel.clearTrigger).disposed(by: disposeBag)
    }
}
