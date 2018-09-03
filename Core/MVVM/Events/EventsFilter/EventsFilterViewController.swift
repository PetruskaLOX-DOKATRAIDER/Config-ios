//
//  EventsFilterViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 24.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public class EventsFilterViewController: UIViewController, NonReusableViewProtocol {
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var applyButton: UIButton!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.EventFilters.title
        view.backgroundColor = .bagdet
        KeyboardAvoiding.avoid(with: scrollViewBottomConstraint, inside: view).disposed(by: rx.disposeBag)
        
        descriptionLabel.textColor = .ichigos
        descriptionLabel.font = .filsonRegularWithSize(15)
        descriptionLabel.text = Strings.EventFilters.description
    
        resetButton.setTitle(Strings.EventFilters.reset, for: .normal)
        cancelButton.setTitle(Strings.EventFilters.cancel, for: .normal)
        applyButton.setTitle(Strings.EventFilters.apply, for: .normal)
        [resetButton, cancelButton, applyButton].forEach {
            $0?.setTitleColor(.ichigos, for: .normal)
            $0?.titleLabel?.font = .filsonMediumWithSize(16)
        }
    }

    public func onUpdate(with viewModel: EventsFilterViewModel, disposeBag: DisposeBag) {
        resetButton.rx.tap.bind(to: viewModel.resetTrigger).disposed(by: disposeBag)
        cancelButton.rx.tap.bind(to: viewModel.cancelTrigger).disposed(by: disposeBag)
        applyButton.rx.tap.bind(to: viewModel.applyTrigger).disposed(by: disposeBag)
        
        viewModel.items.drive(onNext: { [weak self] items in
            guard let strongSelf = self else { return }
            strongSelf.stackView.removeAllSubviews()
            items.forEach{ self?.addEventFilterAndSeparatorView(withViewModel: $0) }
        }).disposed(by: rx.disposeBag)
    }
    
    private func addEventFilterAndSeparatorView(withViewModel viewModel: EventFilterItemViewModel) {
        let height: CGFloat = 56
        let view = EventFilterItemView(frame: CGRect(x: 0, y: 0, width: stackView.bounds.size.width, height: height))
        view.viewModel = viewModel
        stackView.addArrangedSubview(view)
        view.snp.makeConstraints {
            $0.height.equalTo(height)
        }
        addSeparatorView()
    }
    
    private func addSeparatorView() {
        let view = UIView()
        view.backgroundColor = .clear
        stackView.addArrangedSubview(view)
        view.snp.makeConstraints{
            $0.height.equalTo(8)
        }
    }
}
