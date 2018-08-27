//
//  UITextfield+extensions.swift
//  Core
//
//  Created by Oleg Petrychuk on 27.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder ?? "" : "", attributes:[NSAttributedStringKey.foregroundColor: newValue ?? .clear])
        }
    }
    
//    func addToolbar(doneTitle: String,
//                    cancelTitle: String? = nil,
//                    doneAction: (() -> Void)? = nil,
//                    cancelAction: (() -> Void)? = nil) {
//        let defaultAction: (() -> Void)? = { self.resignFirstResponder() }
//        let doneOrDefaultAction = doneAction ?? defaultAction
//        let cancelOrDefaultAction = cancelAction ?? defaultAction
//        let toolbar = KeyboardToolbar.toolbarWithDoneAction(doneOrDefaultAction, cancelAction: cancelOrDefaultAction)
//        toolbar.doneButton.title = doneTitle
//        if let title = cancelTitle {
//            toolbar.cancelButton.title = title
//        } else {
//            toolbar.cancelButton.title = ""
//            toolbar.cancelButton.isEnabled = false
//        }
//        self.inputAccessoryView = toolbar
//    }
}
