//
//  UIDatePicker+extensions.swift
//  Core
//
//  Created by Oleg Petrychuk on 26.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension UIDatePicker {
    func setTextColor(_ color: UIColor) {
        // Recursive label searching dosen't work
        setValue(color, forKey: "textColor")
    }
}
