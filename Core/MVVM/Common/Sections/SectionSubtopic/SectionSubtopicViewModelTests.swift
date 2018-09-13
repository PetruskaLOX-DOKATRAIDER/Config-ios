//
//  SectionSubtopicViewModelTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 13.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class SectionSubtopicViewModelTests: BaseTestCase {
    override func spec() {
        describe("SectionSubtopicViewModel") {
            describe("when create SectionSubtopicViewModel", {
                context("and pass default parameters") {
                    it("should have valid proporties", closure: {
                        let sut = SectionSubtopicViewModelImpl()
                        try? expect(sut.message.toBlocking().first()).to(beEmpty())
                    })
                }
                context("and pass some parameters") {
                    it("should have valid proporties", closure: {
                        let message = String.random()
                        let sut = SectionSubtopicViewModelImpl(message: message)
                        try? expect(sut.message.toBlocking().first()).to(equal(message))
                    })
                }
            })
        }
    }
}
