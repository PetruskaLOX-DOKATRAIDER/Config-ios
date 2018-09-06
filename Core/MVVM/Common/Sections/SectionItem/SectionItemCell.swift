//
//  SectionItemCell.swift
//  Core
//
//  Created by Oleg Petrychuk on 22.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

final class SectionItemCell: UITableViewCell, ModelTransfer, ReusableViewProtocol {
    @IBOutlet private weak var iconWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .amethyst
        
        titleLabel.textColor = .solled
        titleLabel.font = .filsonMediumWithSize(16)
        titleLabel.text = Strings.Storage.title
    }
    
    func onUpdate(with viewModel: SectionItemViewModel, disposeBag: DisposeBag) {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.icon.drive(iconImageView.rx.image).disposed(by: disposeBag)
        viewModel.withDetail.map{ $0 ? .disclosureIndicator : .none }.drive(rx.accessoryType).disposed(by: disposeBag)
        let newWidth: Driver<CGFloat> = viewModel.icon.map{ $0 == nil ? 0 : 44 }
        newWidth.drive(onNext: { [weak self] newWidth in
            self?.iconWidthConstraint.constant = newWidth
            self?.contentView.layoutIfNeeded()
        }).disposed(by: disposeBag)
    }
}
