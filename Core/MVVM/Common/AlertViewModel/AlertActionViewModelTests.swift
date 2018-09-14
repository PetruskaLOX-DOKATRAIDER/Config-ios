//
//  AlertActionViewModelTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 13.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class AlertActionViewModelTests: BaseTestCase {
    override func spec() {
        describe("AlertActionViewModel") {
            describe("when ask proporties") {
                it("should return valid proporties") {
                    let title = String.random()
                    let style = AlertActionStyleViewModel.cancel
                    
                    let sut = AlertActionViewModelImpl(title: title, style: style, action: PublishSubject<Void>())
                    
                    expect(sut.title).to(equal(title))
                    expect(sut.style).to(equal(style))
                    expect(sut.action).toNot(beNil())
                }
            }
        }
    }
}
