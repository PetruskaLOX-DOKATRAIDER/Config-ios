//
//  TextFieldView.swift
//  Core
//
//  Created by Петрічук Олег Аркадійовіч on 21.03.18.
//  Copyright © 2018 MLSDev. All rights reserved.
//

extension UITextField: ReusableViewProtocol {
    open func onUpdate(with viewModel: TextFieldViewModel, disposeBag: DisposeBag) {
        (rx.textInput <-> viewModel.text).disposed(by: disposeBag)
        viewModel.placeholder.drive(rx.placeholder).disposed(by: disposeBag)
        
        rx.controlEvent(.editingDidBegin).bind(to: viewModel.becomeResponder).disposed(by: disposeBag)
        viewModel.shouldResign.drive(rx.resignFirstResponder).disposed(by: disposeBag)
    }
}

extension Reactive where Base: UITextField {
    var placeholder: Binder<String> {
        return Binder(base) { base, value in
            base.placeholder = value
        }
    }
    
    var attributedPlaceholder: Binder<NSAttributedString> {
        return Binder(base) { base, value in
            base.attributedPlaceholder = value
        }
    }
}

extension Reactive where Base: UIControl {
    var resignFirstResponder: Binder<Void> {
        return Binder(base) { base, _ in
            base.resignFirstResponder()
        }
    }
}
