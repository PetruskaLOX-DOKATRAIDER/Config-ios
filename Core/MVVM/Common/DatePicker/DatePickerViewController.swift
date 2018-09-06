//
//  DatePickerViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 25.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class DatePickerViewController: UIViewController, NonReusableViewProtocol {
    @IBOutlet private weak var titleContainerView: UIView!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
   

    override public func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = .bagdet
        separatorView.backgroundColor = .ichigos
        titleContainerView.backgroundColor = .amethyst
        datePicker.setTextColor(.solled)
        
        closeButton.setTitle(Strings.Datepicker.cancel, for: .normal)
        closeButton.setTitleColor(.ichigos, for: .normal)
        closeButton.titleLabel?.font = .filsonRegularWithSize(16)
        
        submitButton.setTitle(Strings.Datepicker.done, for: .normal)
        submitButton.setTitleColor(.ichigos, for: .normal)
        submitButton.titleLabel?.font = .filsonRegularWithSize(16)
        
        titleLabel.textColor = .ichigos
        titleLabel.font = .filsonRegularWithSize(16)
    }
    
    public func onUpdate(with viewModel: DatePickerViewModel, disposeBag: DisposeBag) {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.minimumDate.drive(datePicker.rx.minimumDate).disposed(by: disposeBag)
        viewModel.maximumDate.drive(datePicker.rx.maximumDate).disposed(by: disposeBag)
        closeButton.rx.tap.bind(to: viewModel.closeTrigger).disposed(by: disposeBag)
        submitButton.rx.tap.withLatestFrom( datePicker.rx.date ).bind(to: viewModel.dateTrigger).disposed(by: disposeBag)
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}
