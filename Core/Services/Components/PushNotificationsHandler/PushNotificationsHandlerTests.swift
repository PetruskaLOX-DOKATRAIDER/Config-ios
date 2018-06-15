//
//  PushNotificationsViewModelTests.swift
//  Tests
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Core
import TestsHelper
import XCTest
import Nimble
import RxTest
import RxBlocking

class PushNotificationsServiceTests: BaseTestCase {
    var vm: PushNotificationsHandler!
    var storage: SessionStorageType!
    var service: PushTokenServiceTypeMock!
    let data = Data(base64Encoded: "ilWHLKyBeBXYVMt+Cg28jv+Om9YKYEyhd9fFMzoHf6k=") ?? Data()
    let token = "8A55872CAC817815D854CB7E0A0DBC8EFF8E9BD60A604CA177D7C5333A077FA9"
    
    override func setUp() {
        super.setUp()
        storage = MemorySessionStorage()
        service = PushTokenServiceTypeMock()
        vm = PushNotificationsHandler(service: service, sessionStorage: storage, register: {})
    }
    
    func testRegisterCalledOnceTokenReceived() throws {
        var called: Int = 0
        vm = PushNotificationsHandler(service: service, sessionStorage: storage, register: { called += 1 })
        expect(called).to(equal(0))
        storage.session.value = try Session(token: "token")
        expect(called).to(equal(1))
        storage.session.value = try Session(token: "token")
        expect(called).to(equal(1))
        storage.session.value = nil
        storage.session.value = try Session(token: "token")
        expect(called).to(equal(1))
    }
    
    func testRouteEvent() {
        let observer = scheduler.createObserver(String.self)
        vm.routeToNotes.drive(observer).disposed(by: disposeBag)
        vm.userInfoTrigger.accept(["order_id": "123"])
        XCTAssertEqual(observer.events, [next(0, "123")])
    }
    
    func testTokenDataConversion() throws {
        service.registerTokenReturnValue = .empty()
        storage.session.value = try Session(token: "token")
        vm.deviceTokenTrigger.accept(data)
        expect(self.service.registerTokenReceived).to(equal(token))
    }
    
    func testPushTokenSentOnlyIfAuthTokenPresent() throws {
        service.registerTokenReturnValue = .empty()
        vm.deviceTokenTrigger.accept(data)
        expect(self.service.registerTokenCalled).to(beFalse())
        storage.session.value = try Session(token: "token")
        expect(self.service.registerTokenCalled).to(beTrue())
        service.registerTokenCalled = false
        service.registerTokenReceived = nil
        storage.session.value = nil
        expect(self.service.registerTokenCalled).to(beFalse())
        storage.session.value = try Session(token: "token")
        expect(self.service.registerTokenCalled).to(beTrue())
        expect(self.service.registerTokenReceived).to(equal(token))
    }
}

class PushNotificationsMock: PushNotificationsHandlerType {
    var deviceTokenTrigger = PublishRelay<Data>()
    var userInfoTrigger = PublishRelay<[AnyHashable : Any]>()
    let routeTrigger = PublishRelay<String>()
    var routeToNotes: Driver<String> { return routeTrigger.asDriver() }
}
