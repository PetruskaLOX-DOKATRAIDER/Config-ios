//
//  EasyConstruction.swift
//  TestsHelper
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Core

public protocol EasyConstructionType {
    static func new() -> Self
}
extension String: EasyConstructionType {
    public static func new() -> String { return .init() }
}
extension Int: EasyConstructionType {
    public static func new() -> Int { return .init() }
}
extension Double: EasyConstructionType {
    public static func new() -> Double { return .init() }
}
extension UInt: EasyConstructionType {
    public static func new() -> UInt { return .init() }
}
extension URL: EasyConstructionType {
    //swiftlint:disable:next force_unwrapping
    public static func new() -> URL { return URL(string: "https://google.com")! }
}
extension Date: EasyConstructionType {
    public static func new() -> Date { return .init() }
}
extension Bool: EasyConstructionType {
    public static func new() -> Bool { return .init() }
}
extension Optional: EasyConstructionType {
    public static func new() -> Wrapped? { return .none }
}
extension Array: EasyConstructionType {
    public static func new() -> [Element] { return .init() }
}
