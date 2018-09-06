//
//  EventsFilterViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 24.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class EventsFilterViewController: UIViewController, NonReusableViewProtocol {
    @IBOutlet private weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var applyButton: UIButton!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.EventFilters.title
        view.backgroundColor = .bagdet
        KeyboardAvoiding.avoid(with: scrollViewBottomConstraint, inside: view).disposed(by: rx.disposeBag)
        
        descriptionLabel.textColor = .ichigos
        descriptionLabel.font = .filsonRegularWithSize(15)
        descriptionLabel.text = Strings.EventFilters.description
    
        resetButton.setTitle(Strings.EventFilters.reset, for: .normal)
        resetButton.setTitleColor(.ichigos, for: .normal)
        resetButton.titleLabel?.font = .filsonMediumWithSize(16)
        
        closeButton.setTitle(Strings.EventFilters.cancel, for: .normal)
        closeButton.setTitleColor(.ichigos, for: .normal)
        closeButton.titleLabel?.font = .filsonMediumWithSize(16)
        
        applyButton.setTitle(Strings.EventFilters.apply, for: .normal)
        applyButton.setTitleColor(.ichigos, for: .normal)
        applyButton.titleLabel?.font = .filsonMediumWithSize(16)
    }

    public func onUpdate(with viewModel: EventsFilterViewModel, disposeBag: DisposeBag) {
        viewModel.items.drive(onNext: { [weak self] in self?.mapItems($0) }).disposed(by: rx.disposeBag)
        resetButton.rx.tap.bind(to: viewModel.resetTrigger).disposed(by: disposeBag)
        closeButton.rx.tap.bind(to: viewModel.closeTrigger).disposed(by: disposeBag)
        applyButton.rx.tap.bind(to: viewModel.applyTrigger).disposed(by: disposeBag)
    }
    
    private func mapItems(_ items: [EventFilterItemViewModel]) {
        stackView.removeAllSubviews()
        items.forEach { vm in
            addEventFilterView(withViewModel: vm)
            addSeparatorView()
        }
    }
    
    private func addEventFilterView(withViewModel viewModel: EventFilterItemViewModel) {
        let height: CGFloat = 56
        let view = EventFilterItemView(frame: CGRect(x: 0, y: 0, width: stackView.bounds.size.width, height: height))
        view.viewModel = viewModel
        stackView.addArrangedSubview(view)
        view.snp.makeConstraints {
            $0.height.equalTo(height)
        }
    }
    
    private func addSeparatorView() {
        let view = UIView()
        view.backgroundColor = .clear
        stackView.addArrangedSubview(view)
        view.snp.makeConstraints {
            $0.height.equalTo(8)
        }
    }
}
