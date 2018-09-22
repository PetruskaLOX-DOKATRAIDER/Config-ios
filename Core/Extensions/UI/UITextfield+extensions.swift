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
            attributedPlaceholder = NSAttributedString(
                string: placeholder != nil ? placeholder ?? "" : "",
                attributes:[NSAttributedStringKey.foregroundColor: newValue ?? .clear]
            )
        }
    }
}
