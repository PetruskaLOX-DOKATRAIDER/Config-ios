//
//  BasdeTestCase.swift
//  Tests
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Quick
import XCTest
import RxSwift
import RxTest

class BaseTestCase: QuickSpec {
    var scheduler = TestScheduler(initialClock: 0)
    var disposeBag = DisposeBag()
}

extension Bundle {
    public static var test: Bundle { return Bundle(for: BaseTestCase.self) }
}
