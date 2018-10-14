//
//  Random.swift
//  TestsHelper
//
//  Created by Oleg Petrychuk on 20.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol Random {
    static func random() -> Self
}

extension Array: Random {
    private static func randomElement() -> Element? {
        guard Element.self is Random.Type else {
            return nil
        }
        return (Element.self as? Random.Type)?.random() as? Element
    }
    
    public static func random() -> [Element] {
        return (0...Int(arc4random() % 3))
            .map { _ in randomElement() }
            .compactMap { $0 }
    }
}

extension Optional: Random {
    private static func randomElement() -> Wrapped? {
        guard Wrapped.self is Random.Type else {
            return nil
        }
        return (Wrapped.self as? Random.Type)?.random() as? Wrapped
    }
    
    public static func random() -> Wrapped? {
        return Int(arc4random() % 2) == 0
            ? nil
            : randomElement()
    }
}

extension String: Random {
    public static func random() -> String {
        return NSUUID().uuidString
    }
}

extension Int: Random {
    public static func random() -> Int {
        return Int(arc4random() % 200)
    }
}

extension Int32: Random {
    public static func random() -> Int32 {
        return Int32(arc4random() % 300)
    }
}

extension Int64: Random {
    public static func random() -> Int64 {
        return Int64(arc4random() % 300)
    }
}

extension Double: Random {
    public static func random() -> Double {
        return Double(arc4random() % 1000) / 100
    }
}

extension Float: Random {
    public static func random() -> Float {
        return Float(arc4random() % 1000) / 100
    }
}

extension Data: Random {
    public static func random() -> Data {
        let bytes = [UInt32](repeating: 0, count: 10).map { _ in arc4random() }
        return Data(bytes: bytes, count: 10 )
    }
}

extension Date: Random {
    public static func random() -> Date {
        return Date(timeIntervalSince1970: Double.random())
    }
}

extension NSError {
    public static func random() -> NSError {
        return NSError(domain: .random(), code: .random(), userInfo: nil)
    }
}
