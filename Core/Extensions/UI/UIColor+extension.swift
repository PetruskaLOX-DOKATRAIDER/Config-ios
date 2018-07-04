//
//  UIColor+extension.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1)
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    private enum RGBA: Int {
        case red; case green; case blue; case alpha
    }
    
    convenience init(rgbaString: String) {
        var assoc: [RGBA: CGFloat] = [.red:0, .green:0, .blue:0, .alpha:0]
        
        let components = rgbaString.components(separatedBy: ":")
        for i in 0..<components.count {
            let component = components[i]
            if let rgbIndex = RGBA(rawValue: i),
                let floatValue = Float(component) {
                let number = CGFloat(floatValue) / 255
                assoc[rgbIndex] = number
            }
        }
        guard let red = assoc[.red], let green = assoc[.green], let blue = assoc[.blue], let alpha = assoc[.alpha] else { fatalError("Can't create color with rgbaString: \(rgbaString)") }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

public extension UIColor {
    static var amethyst: UIColor { return UIColor(hexString: "#434343") }
    static var laded: UIColor { return UIColor(hexString: "#939393") }
    static var ichigos: UIColor { return UIColor(hexString: "#FD375C") }
    static var navos: UIColor { return UIColor(hexString: "#181818") }
    static var bagdet: UIColor { return UIColor(hexString: "#0D0D0D") }
    static var tapped: UIColor { return UIColor(hexString: "#181818") }
    static var snowWhite: UIColor { return .white }
}
