//
//  UIView+extensions.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor : UIColor {
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.white.cgColor)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var patternColorImage: String {
        get {
            return ""
        }
        set {
            backgroundColor = UIColor(patternImage: UIImage(named: newValue) ?? UIImage())
        }
    }
    
    func applyRoundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        layoutIfNeeded()
        let layer = CAShapeLayer()
        layer.frame = bounds
        layer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                                  cornerRadii: CGSize(width: radius, height: radius)).cgPath
        self.layer.mask = layer
    }
    
    func applyShadow(_ offset: CGSize = CGSize(width: 0, height: 1), radius: CGFloat = 3, opacity: Float = 0.1) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
    }
    
    func addFillConstraints(_ subview: UIView, insets: UIEdgeInsets = UIEdgeInsets()){
        subview.translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: subview.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: subview.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: subview.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: subview.bottomAnchor).isActive = true
    }
}
