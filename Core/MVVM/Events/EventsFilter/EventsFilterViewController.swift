//
//  EventsFilterViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 24.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public class EventsFilterViewController: UIViewController, NonReusableViewProtocol {
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var applyButton: UIButton!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.setTitleColor(.ichigos, for: .normal)
        cancelButton.titleLabel?.font = .filsonMediumWithSize(16)
        cancelButton.setTitle(Strings.EventFilters.cancel, for: .normal)
        
        applyButton.setTitleColor(.ichigos, for: .normal)
        applyButton.titleLabel?.font = .filsonMediumWithSize(16)
        applyButton.setTitle(Strings.EventFilters.apply, for: .normal)
    }
    
    public func onUpdate(with viewModel: EventsFilterViewModel, disposeBag: DisposeBag) {
        cancelButton.rx.tap.bind(to: viewModel.cancelTrigger).disposed(by: disposeBag)
        applyButton.rx.tap.bind(to: viewModel.applyTrigger).disposed(by: disposeBag)
    }
}
