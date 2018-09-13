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
            describe("when create AlertActionViewModel", {
                context("and pass default parameters") {
                    it("should have valid proporties", closure: {
                        let sut = AlertActionViewModelImpl(title: "")
                        expect(sut.style).to(equal(AlertActionStyleViewModel.`default`))
                        expect(sut.action).to(beNil())
                    })
                }
                context("and pass some parameters") {
                    it("should have valid proporties", closure: {
                        let title = String.random()
                        let style = AlertActionStyleViewModel.cancel
                        
                        let sut = AlertActionViewModelImpl(title: title, style: style, action: PublishSubject<Void>())
                        expect(sut.title).to(equal(title))
                        expect(sut.style).to(equal(style))
                        expect(sut.action).toNot(beNil())
                    })
                }
            })
        }
    }
}
