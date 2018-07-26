//
//  UIDatePicker+extensions.swift
//  Core
//
//  Created by Oleg Petrychuk on 26.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension UIDatePicker {
    func setTextColor(_ color: UIColor) {
//        TODO: Find better solution
//        let labels: [UILabel] = findSubviewsOf()
//        labels.forEach{ $0.textColor = color }
        setValue(color, forKey: "textColor")
    }
}
