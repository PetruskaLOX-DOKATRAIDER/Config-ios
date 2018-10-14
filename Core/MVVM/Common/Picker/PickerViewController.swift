//
//  PickerViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 25.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class PickerViewController: UIViewController, NonReusableViewProtocol {
    @IBOutlet private weak var titleContainerView: UIView!
    @IBOutlet private weak var pickerView: UIPickerView!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = Colors.bagdet
        separatorView.backgroundColor = Colors.ichigos
        titleContainerView.backgroundColor = Colors.amethyst
        
        closeButton.setTitle(Strings.Picker.cancel, for: .normal)
        closeButton.setTitleColor(Colors.ichigos, for: .normal)
        closeButton.titleLabel?.font = .filsonRegularWithSize(16)
        
        submitButton.setTitle(Strings.Picker.done, for: .normal)
        submitButton.setTitleColor(Colors.ichigos, for: .normal)
        submitButton.titleLabel?.font = .filsonRegularWithSize(16)
        
        titleLabel.textColor = Colors.ichigos
        titleLabel.font = .filsonRegularWithSize(16)
    }
    
    public func onUpdate(with viewModel: PickerViewModel, disposeBag: DisposeBag) {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.itemTitles.drive(pickerView.rx.itemTitles){ $1 }.disposed(by: disposeBag)
        closeButton.rx.tap.bind(to: viewModel.closeTrigger).disposed(by: disposeBag)
        let currentPickerIndex = submitButton.rx.tap.asDriver().map { [weak self] in
            self?.pickerView.selectedRow(inComponent: 0)
        }
        currentPickerIndex.filterNil().drive(viewModel.itemAtIndexTrigger).disposed(by: disposeBag)
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}
