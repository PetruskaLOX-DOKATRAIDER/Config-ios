//
//  EventFilterItemView.swift
//  Core
//
//  Created by Oleg Petrychuk on 26.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

final class EventFilterItemView: LoadableView, NonReusableViewProtocol {
    @IBOutlet private weak var detailImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var detailImageView: UIImageView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var selectionButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = Colors.amethyst
        
        titleLabel.textColor = Colors.solled
        titleLabel.font = .filsonMediumWithSize(15)
    }
    
    func onUpdate(with viewModel: EventFilterItemViewModel, disposeBag: DisposeBag) {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.icon.drive(iconImageView.rx.image).disposed(by: disposeBag)
        viewModel.withDetail.map{ !$0 }.drive(detailImageView.rx.isHidden).disposed(by: disposeBag)
        viewModel.withDetail.drive(onNext: { [weak self] withDetail in
            self?.detailImageViewWidthConstraint.constant = withDetail ? 12 : 0
            self?.layoutIfNeeded()
        }).disposed(by: disposeBag)
        selectionButton.rx.tap.bind(to: viewModel.selectionTrigger).disposed(by: disposeBag)
    }
}
