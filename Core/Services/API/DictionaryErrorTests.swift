//
//  DictionaryErrorTests.swift
//  Tests
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//


import XCTest
import TestsHelper
import Core

class DictionaryErrorTests: BaseTestCase {
    func testBackendErrorFromRawRepresentable() {
        XCTAssert(try TestError(backendKey: "case1") == .case1)
        XCTAssert(try TestError(backendKey: "case2") == .case2)
        
        do {
            _ = try TestError(backendKey: "unsupported")
            XCTFail()
        } catch let error as BackendErrorBuildingError {
            XCTAssert(error == .unsupportedKey)
        } catch {
            XCTFail()
        }
    }
    
    func testKeyValueParameterConstruction() {
        let error = DictionaryError<TestError>(key: "case1", value: "value")
        XCTAssert(error.errors == [.case1: ["value"]])
    }
    func testArrayAsValueConstruction() {
        let error = DictionaryError<TestError>(["case1": ["value", "value2"], "case2": []])
        XCTAssert(error.errors == [.case1: ["value", "value2"], .case2: []])
    }
    func testStringAsValueConstruction() {
        let error = DictionaryError<TestError>(["case1": "value", "case2": "value2"])
        XCTAssert(error.errors == [.case1: ["value"], .case2: ["value2"]])
    }
}

public func ==<T, U: Equatable>(_ lhs: [T:[U]], _ rhs: [T:[U]]) -> Bool { 
    return lhs.lazy.elementsEqual(rhs) {
        $0.0 == $1.0 && $0.1 == $1.1
    }
}


enum TestError: String, BackendError, Error {
    case case1
    case case2
}
