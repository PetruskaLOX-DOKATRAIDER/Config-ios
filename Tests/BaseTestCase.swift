//
//  BasdeTestCase.swift
//  Tests
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

class BaseTestCase: XCTestCase {
    var scheduler : TestScheduler!
    var disposeBag = DisposeBag()
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
}

extension Bundle {
    public static var test: Bundle { return Bundle(for: BaseTestCase.self) }
}
