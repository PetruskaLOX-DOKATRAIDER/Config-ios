//
//  DatePickerViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 25.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public class DatePickerViewController: UIViewController, NonReusableViewProtocol {
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var titleContainerView: UIView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = .bagdet
        separatorView.backgroundColor = .ichigos
        titleContainerView.backgroundColor = .amethyst
        datePicker.setTextColor(.solled)
        
        cancelButton.setTitle(Strings.Datepicker.cancel, for: .normal)
        cancelButton.setTitleColor(.ichigos, for: .normal)
        cancelButton.titleLabel?.font = .filsonRegularWithSize(16)
        
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
        cancelButton.rx.tap.bind(to: viewModel.cancelTrigger).disposed(by: disposeBag)
        submitButton.rx.tap.withLatestFrom(datePicker.rx.date).bind(to: viewModel.dateTrigger).disposed(by: disposeBag)
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}
