//
//  TwoWayBinding.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

infix operator <-> : DefaultPrecedence

func nonMarkedText(_ textInput: UITextInput) -> String? {
    let start = textInput.beginningOfDocument
    let end = textInput.endOfDocument
    
    guard   let rangeAll = textInput.textRange(from: start, to: end),
            let text = textInput.text(in: rangeAll)
        else { return nil }
    
    guard   let markedTextRange = textInput.markedTextRange,
            let startRange = textInput.textRange(from: start, to: markedTextRange.start),
            let endRange = textInput.textRange(from: markedTextRange.end, to: end)
        else { return text }
    
    return (textInput.text(in: startRange) ?? "") + (textInput.text(in: endRange) ?? "")
}

@discardableResult
public func <-> <Base>(textInput: TextInput<Base>, variable: Variable<String>) -> Disposable {
    let bindToUIDisposable = variable.asObservable().bind(to: textInput.text)
    let bindToVariable = textInput.text
        .subscribe(onNext: { [weak base = textInput.base] _ in
            guard let base = base else { return }
            
            let nonMarkedTextValue = nonMarkedText(base)
            
            /**
             In some cases `textInput.textRangeFromPosition(start, toPosition: end)` will return nil even though the underlying
             value is not nil. This appears to be an Apple bug. If it's not, and we are doing something wrong, please let us know.
             The can be reproed easily if replace bottom code with
             
             if nonMarkedTextValue != variable.value {
             variable.value = nonMarkedTextValue ?? ""
             }
             and you hit "Done" button on keyboard.
             */
            if let nonMarkedTextValue = nonMarkedTextValue, nonMarkedTextValue != variable.value {
                variable.value = nonMarkedTextValue
            }
            (textInput.base as? UIView)?.setNeedsDisplay()
        }, onCompleted: { bindToUIDisposable.dispose() })
    
    return Disposables.create(bindToUIDisposable, bindToVariable)
}
