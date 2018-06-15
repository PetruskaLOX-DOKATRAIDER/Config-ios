//
//  UnauthorizedPluginTests.swift
//  Tests
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Core
import TestsHelper
import Nimble
import RxTest
import TRON
import Alamofire

class UnauthorizedPluginTests: BaseTestCase {
    var plugin: UnauthorizedPlugin!
    var tron: TRON!
    
    override func setUp() {
        super.setUp()
        tron = TRON(baseURL: "http://google.com")
        plugin = UnauthorizedPlugin()
    }
    
    func testUnauthBehaiviour() {
        let unauthObserver = scheduler.createObserver(Void.self)
        let unsupObserver = scheduler.createObserver(Void.self)
        plugin.unauthorized.drive(unauthObserver).disposed(by: disposeBag)
        plugin.unsupported.drive(unsupObserver).disposed(by: disposeBag)
        let request: APIRequest<Int, Int> = tron.swiftyJSON.request("status/200")
        let response = HTTPURLResponse(url: .new(), statusCode: ServerErrorStatus.unauthorized.rawValue, httpVersion: nil, headerFields: nil)
        plugin.willProcessResponse(response: (nil, response, nil, nil), forRequest: Alamofire.request(""), formedFrom: request)
        expect(unauthObserver.events.count).to(equal(1))
        expect(unsupObserver.events.count).to(equal(0))
    }
    func testUnsupBehaiviour() {
        let unauthObserver = scheduler.createObserver(Void.self)
        let unsupObserver = scheduler.createObserver(Void.self)
        plugin.unauthorized.drive(unauthObserver).disposed(by: disposeBag)
        plugin.unsupported.drive(unsupObserver).disposed(by: disposeBag)
        let request: APIRequest<Int, Int> = tron.swiftyJSON.request("status/200")
        let response = HTTPURLResponse(url: .new(), statusCode: ServerErrorStatus.unsupportedVersion.rawValue, httpVersion: nil, headerFields: nil)
        plugin.willProcessResponse(response: (nil, response, nil, nil), forRequest: Alamofire.request(""), formedFrom: request)
        expect(unauthObserver.events.count).to(equal(1))
        expect(unsupObserver.events.count).to(equal(1))
    }
    func testNoResponseBehaiviour() {
        let unauthObserver = scheduler.createObserver(Void.self)
        let unsupObserver = scheduler.createObserver(Void.self)
        plugin.unauthorized.drive(unauthObserver).disposed(by: disposeBag)
        plugin.unsupported.drive(unsupObserver).disposed(by: disposeBag)
        let request: APIRequest<Int, Int> = tron.swiftyJSON.request("status/200")
        plugin.willProcessResponse(response: (nil, nil, nil, nil), forRequest: Alamofire.request(""), formedFrom: request)
        expect(unauthObserver.events.count).to(equal(0))
        expect(unsupObserver.events.count).to(equal(0))
    }
}
