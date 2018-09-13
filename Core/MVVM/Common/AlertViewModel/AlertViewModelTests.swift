//
//  AlertViewModelTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 13.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class AlertViewModelTests: BaseTestCase {
    override func spec() {
        describe("AlertViewModel") {
            describe("when create AlertViewModel", {
                context("and pass default parameters") {
                    it("should have valid proporties", closure: {
                        let sut = AlertViewModelImpl()
                        expect(sut.title).to(beNil())
                        expect(sut.message).to(beNil())
                        expect(sut.style).to(equal(AlertViewModelStyle.alert))
                        expect(sut.actions).to(beEmpty())
                    })
                }
                context("and pass some parameters") {
                    it("should have valid proporties", closure: {
                        let title = String.random()
                        let style = AlertViewModelStyle.actionSheet
                        let action1 = AlertActionViewModelImpl(title: String.random())
                        let action2 = AlertActionViewModelImpl(title: String.random())
                        let actions = [action1, action2]
                        
                        let sut = AlertViewModelImpl(title: title, message: nil, style: style, actions: actions)
                        expect(sut.title).to(equal(title))
                        expect(sut.message).to(beNil())
                        expect(sut.style).to(equal(style))
                        expect(sut.actions.count).to(equal(actions.count))
                        expect(sut.actions.first as? AlertActionViewModelImpl).to(equal(action1))
                        expect(sut.actions.last as? AlertActionViewModelImpl).to(equal(action2))
                    })
                }
            })
        }
    }
}
