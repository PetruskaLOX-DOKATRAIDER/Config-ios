//
//  Attributer.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension String {
    func attributed() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }
}

extension NSAttributedString {
    func attributed() -> NSMutableAttributedString {
        return NSMutableAttributedString(attributedString: self)
    }
}

extension NSAttributedString {
    var fullLengthRange : NSRange {
        return NSRange(location: 0, length: self.length)
    }
}

extension NSMutableAttributedString {
    func setColor(_ color: UIColor) -> NSMutableAttributedString {
        return setColor(color, range: fullLengthRange)
    }
    
    func setFont(_ font: UIFont) -> NSMutableAttributedString {
        return setFont(font, range: fullLengthRange)
    }
    
    func setAttributes(_ attributes: [NSAttributedStringKey : Any]) -> NSMutableAttributedString {
        setAttributes(attributes, range: fullLengthRange)
        return self
    }
    
    func setColor(_ color: UIColor, range: NSRange) -> NSMutableAttributedString {
        addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        return self
    }
    
    func setFont(_ font: UIFont, range: NSRange) -> NSMutableAttributedString {
        addAttribute(NSAttributedStringKey.font, value: font, range: range)
        return self
    }
    
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
    }
}

func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSMutableAttributedString {
    let result = NSMutableAttributedString(attributedString: lhs)
    result.append(rhs)
    return result
}

func += (lhs: inout NSMutableAttributedString, rhs: NSAttributedString) {
    let left = lhs
    left.append(rhs)
    lhs = left // to let lhs willSet didSet work
}
