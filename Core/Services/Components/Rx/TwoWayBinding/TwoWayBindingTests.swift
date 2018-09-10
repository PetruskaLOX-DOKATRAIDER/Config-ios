//
//  TwoWayBindingTests.swift
//  Tests
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Core
import Nimble
import XCTest
import RxSwift
import RxCocoa

class RXTwoWayBindingsTests: XCTestCase {
    func testBindingTextField() {
        let vc = UIViewController()
        AppRouter.rootViewController = vc
        vc.loadViewIfNeeded()
        let textfield = UITextField()
        let variable = BehaviorRelay(value: "test")
        vc.view.addSubview(textfield)
        textfield.becomeFirstResponder()
        expect(variable.value).to(equal("test"))
        expect(textfield.text).to(equal(""))
        textfield.rx.textInput <-> variable
        expect(variable.value).to(equal("test"))
        expect(textfield.text).to(equal("test"))
        variable.accept("test2")
        expect(variable.value).to(equal("test2"))
        expect(textfield.text).to(equal("test2"))
        textfield.text = "test3"
        textfield.sendActions(for: .valueChanged)
        expect(variable.value).to(equal("test3"))
        expect(textfield.text).to(equal("test3"))
    }
}
