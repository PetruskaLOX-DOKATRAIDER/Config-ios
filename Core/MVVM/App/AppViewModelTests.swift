//
//  AppViewModelTests.swift
//  GoDrive
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

class AppViewModelTests: BaseTestCase {
    var viewModel: AppViewModel!
    var sessionStorage: MemorySessionStorage!
    var environment: AppEnvironmentTypeMock!
    var unauthTrigger = PublishRelay<Void>()
    var unsupTrigger = PublishRelay<Void>()
    
    override func setUp() {
        super.setUp()
        sessionStorage = MemorySessionStorage()
        environment = AppEnvironmentTypeMock(appVersion: "", isDebug: false)
        viewModel = AppViewModel(sessionStorage: sessionStorage,
                                 authPlugin: AuthPluginTypeMock(unauthorized: unauthTrigger.asDriver(),
                                                                unsupported: unsupTrigger.asDriver()),
                                 environment: environment)
    }
    
    func testSignIn() throws {
        let signedInObserver = scheduler.createObserver(Void.self)
        viewModel.shouldRouteSignedIn.drive(signedInObserver).disposed(by: disposeBag)
        expect(signedInObserver.events.count).to(equal(0))
        
        sessionStorage.session.value = try Session(token: "token")
        expect(signedInObserver.events.count).to(equal(1))
        
        sessionStorage.session.value = nil
        expect(signedInObserver.events.count).to(equal(1))
    }
    
    func testSignOut() throws {
        let signedOutObserver = scheduler.createObserver(Void.self)
        viewModel.shouldRouteSignedOut.drive(signedOutObserver).disposed(by: disposeBag)
        expect(signedOutObserver.events.count).to(equal(1))
        
        sessionStorage.session.value = try Session(token: "token")
        expect(signedOutObserver.events.count).to(equal(1))
        
        sessionStorage.session.value = nil
        expect(signedOutObserver.events.count).to(equal(2))
    }
    
    func testUnsupVersionAlert() {
        let observer = scheduler.createObserver(URL?.self)
        viewModel.shouldAlertUnsupportedVersion.drive(observer).disposed(by: disposeBag)
        unsupTrigger.accept(())
        expect(observer.events.count).toEventually(equal(1))
    }
    
    func testTokenErased() throws {
        sessionStorage.session.value = try Session.init(token: "token")
        unauthTrigger.accept(())
        expect(self.sessionStorage.session.value).to(beNil())
    }
}
