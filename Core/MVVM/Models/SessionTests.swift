//
//  SessionTests.swift
//  Tests
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import XCTest
import Core
import SwiftyJSON
import Nimble

class SessionTests: XCTestCase {
    var json: JSON!
    
    override func setUp() {
        super.setUp()
        json = [:]
    }
    
    func testTokenValidation() {
        json = ["auth_token": 123]
        expect { try Session(json: self.json) }.to(throwError {
            expect($0 as? String).to(equal("Missing token value"))
        })
        
        json = ["auth_token": ""]
        expect { try Session(json: self.json) }.to(throwError {
            expect($0 as? String).to(equal("Token cannot be empty"))
        })
        
        json = ["auth_token": "123"]
        expect { try Session(json: self.json) }.toNot(throwError())
    }
}
