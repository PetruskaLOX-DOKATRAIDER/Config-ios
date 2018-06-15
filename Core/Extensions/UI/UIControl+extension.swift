//
//  UIControl+extension.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// allow us to chain next responders example: txtFld1 >| txtFld2 >| btn1
infix operator >|: AdditionPrecedence
@discardableResult
public func >| (_ l: UIControl, _ r: UIControl) -> UIControl {
    l.rx.controlEvent(.editingDidEndOnExit).map(r.becomeFirstResponder).subscribe().disposed(by: l.rx.disposeBag)
    return r
}
@discardableResult
public func >| (_ l: UIControl, _ r: UIBarButtonItem) -> UIBarButtonItem {
    l.rx.controlEvent(.editingDidEndOnExit).bind(onNext: {  [weak r] in
        l.resignFirstResponder()
        guard let action = r?.action else { return }
        UIApplication.shared.sendAction(action, to: r?.target, from: nil, for: nil)
    }).disposed(by: l.rx.disposeBag)
    return r
}
@discardableResult
public func >| (_ l: UIControl, _ r: UIButton) -> UIButton {
    l.rx.controlEvent(.editingDidEndOnExit).bind(onNext: {  [weak r] in
        l.resignFirstResponder()
        _ = r?.sendActions(for: .touchUpInside)
    }).disposed(by: l.rx.disposeBag)
    return r
}
