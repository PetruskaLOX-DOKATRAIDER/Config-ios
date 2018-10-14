//
//  TextFieldView.swift
//  Core
//
//  Created by Oleg Petrychuk on 21.03.18.
//  Copyright © 2018 MLSDev. All rights reserved.
//

extension UITextField: ReusableViewProtocol {
    public func onUpdate(with viewModel: TextFieldViewModel, disposeBag: DisposeBag) {
        (rx.textInput <-> viewModel.text).disposed(by: disposeBag)
        viewModel.placeholder.drive(rx.placeholder).disposed(by: disposeBag)
        rx.controlEvent(.editingDidBegin).bind(to: viewModel.becomeResponder).disposed(by: disposeBag)
        viewModel.shouldResign.drive(rx.resignFirstResponder).disposed(by: disposeBag)
    }
}

extension Reactive where Base: UITextField {
    var placeholder: Binder<String> {
        return Binder(base) { textField, placeholder in
            textField.placeholder = placeholder
        }
    }
    
    var attributedPlaceholder: Binder<NSAttributedString> {
        return Binder(base) { textField, attributedPlaceholder in
            textField.attributedPlaceholder = attributedPlaceholder
        }
    }
}

extension Reactive where Base: UIControl {
    var resignFirstResponder: Binder<Void> {
        return Binder(base) { textField, _ in
            textField.resignFirstResponder()
        }
    }
}
