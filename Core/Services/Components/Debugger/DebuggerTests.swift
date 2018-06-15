//
//  DebuggerTests.swift
//  Tests
//
//  Created by Vladislav Khambir on 2/13/18.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Core
import XCTest
import Nimble

class DebuggerTests: XCTestCase {
    var logMessage: String!
    var deinitMessage: String!
    
    override func setUp() {
        super.setUp()
        logMessage = ""
        deinitMessage = ""
    }
    
    func testInitDeinitMessage() {
        do {
            let vc = UIViewController()
            Debugger(vc) { self.logMessage = $0 }
            expect(self.logMessage).to(equal("[😇init] \(String(describing: Swift.type(of: vc))) instance: \(Unmanaged<AnyObject>.passUnretained(vc).toOpaque())"))
            deinitMessage = "[😈deinit] \(String(describing: Swift.type(of: vc))) instance: \(Unmanaged<AnyObject>.passUnretained(vc).toOpaque())"
        }
        
        expect(self.logMessage).to(equal(deinitMessage))
    }
    
    func testDebugPrint() {
        do {
            let instance = FakeClass { self.logMessage = $0 }
            expect(self.logMessage).to(equal("[😇init] name: FakeClass instance: \(Unmanaged<AnyObject>.passUnretained(instance.debugger).toOpaque())"))
            deinitMessage = "[😈deinit] name: FakeClass instance: \(Unmanaged<AnyObject>.passUnretained(instance.debugger).toOpaque())"
        }
        
        expect(self.logMessage).to(equal(deinitMessage))
    }
    
    func testDebugWithoutInitMessage() {
        do {
            let instance = FakeClass(logInit: false) { self.logMessage = $0 }
            expect(self.logMessage).toNot(equal("[😇init] name: FakeClass instance: \(Unmanaged<AnyObject>.passUnretained(instance.debugger).toOpaque())"))
            deinitMessage = "[😈deinit] name: FakeClass instance: \(Unmanaged<AnyObject>.passUnretained(instance.debugger).toOpaque())"
        }
        
        expect(self.logMessage).to(equal(deinitMessage))
    }
    
    func testDebugWithoutDeinitMessage() {
        do {
            let instance = FakeClass(logDeinit: false) { self.logMessage = $0 }
            expect(self.logMessage).to(equal("[😇init] name: FakeClass instance: \(Unmanaged<AnyObject>.passUnretained(instance.debugger).toOpaque())"))
            deinitMessage = "[😈deinit] name: FakeClass instance: \(Unmanaged<AnyObject>.passUnretained(instance.debugger).toOpaque())"
        }
        
        expect(self.logMessage).toNot(equal(deinitMessage))
    }
}

private class FakeClass {
    let debugger: DebugPrint
    let logger: (String) -> Void
    
    init(logInit: Bool = true, logDeinit: Bool = true, logger: @escaping (String) -> Void) {
        self.logger = logger
        self.debugger = DebugPrint("FakeClass", logInit: logInit, logDeinit: logDeinit, logger: logger)
    }
}
