//
//  StorageMock.swift
//  TestsHelper
//
//  Created by Петрічук Олег Аркадійовіч on 23.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// Dosen't work with Automockable
//public class StorageMock: Storage {
//    
//    
//    public init() {
//    }
//    
//    public var boolForKeyCalled = false
//    public var boolForKeyReceived: String?
//    public var boolForKeyReturnValue: Bool!
//    public func bool(forKey defaultName: String) -> Bool {
//        boolForKeyCalled = true
//        boolForKeyReceived = defaultName
//        return boolForKeyReturnValue
//    }
//    
//    public var objectForKeyCalled = false
//    public var objectForKeyReceived: String?
//    public var objectForKeyReturnValue: Any?
//    public func object(forKey defaultName: String) -> Any? {
//        objectForKeyCalled = true
//        objectForKeyReceived = defaultName
//        return objectForKeyReturnValue
//    }
//    
//    public var stringForKeyCalled = false
//    public var stringForKeyReceived: String?
//    public var stringtForKeyReturnValue: String?
//    public func string(forKey defaultName: String) -> String? {
//        stringForKeyCalled = true
//        stringForKeyReceived = defaultName
//        return stringtForKeyReturnValue
//    }
//    
//    public var doubleForKeyCalled = false
//    public var doubleForKeyReceived: String?
//    public var doubleForKeyReturnValue: Double!
//    public func double(forKey defaultName: String) -> Double {
//        doubleForKeyCalled = true
//        doubleForKeyReceived = defaultName
//        return doubleForKeyReturnValue
//    }
//    
//    public var integerForKeyCalled = false
//    public var integerForKeyReceived: String?
//    public var integerForKeyReturnValue: Int!
//    public func integer(forKey defaultName: String) -> Int {
//        integerForKeyCalled = true
//        integerForKeyReceived = defaultName
//        return integerForKeyReturnValue
//    }
//    
//    public var setDoubleCalled = false
//    public var setDoubleReceived: Double?
//    public func set(_ value: Double, forKey defaultName: String) {
//        setDoubleCalled = true
//        setDoubleReceived = value
//    }
//    
//    public var setAnyCalled = false
//    public var setAnyReceived: Any?
//    public func set(_ value: Any?, forKey defaultName: String) {
//        setAnyCalled = true
//        setAnyReceived = value
//    }
//    
//    public var setIntCalled = false
//    public var setIntReceived: Int?
//    public func set(_ value: Int, forKey defaultName: String) {
//        setIntCalled = true
//        setIntReceived = value
//    }
//}
