//
//  PickerViewController.swift
//  Config
//
//  Created by Oleg Petrychuk on 25.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public class PickerViewController: UIViewController, NonReusableViewProtocol {
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var pickerView: UIPickerView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var titleContainerView: UIView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = .bagdet
        separatorView.backgroundColor = .ichigos
        titleContainerView.backgroundColor = .amethyst
        
        cancelButton.setTitle(Strings.Picker.cancel, for: .normal)
        cancelButton.setTitleColor(.ichigos, for: .normal)
        cancelButton.titleLabel?.font = .filsonRegularWithSize(16)
        
        submitButton.setTitle(Strings.Picker.done, for: .normal)
        submitButton.setTitleColor(.ichigos, for: .normal)
        submitButton.titleLabel?.font = .filsonRegularWithSize(16)
        
        titleLabel.textColor = .ichigos
        titleLabel.font = .filsonRegularWithSize(16)
    }
    
    public func onUpdate(with viewModel: PickerViewModel, disposeBag: DisposeBag) {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: disposeBag)
        cancelButton.rx.tap.bind(to: viewModel.cancelTrigger).disposed(by: disposeBag)
        viewModel.itmeTitles.drive(pickerView.rx.itemTitles){ $1 }.disposed(by: disposeBag)
//        viewModel.itmeTitles.drive(pickerView.rx.itemAttributedTitles){
//            return NSAttributedString(string: "\($1)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.ichigos])
//        }.disposed(by: disposeBag)
        let currentPickerIndex = submitButton.rx.tap.asDriver().map{ [weak self] in self?.pickerView.selectedRow(inComponent: 0) }
        currentPickerIndex.filterNil().drive(viewModel.itemAtIndexTrigger).disposed(by: disposeBag)
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}
