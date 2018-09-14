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
            describe("wwhen ask proporties") {
                it("should return valid proporties") {
                    let message = String.random()
                    
                    let sut = SectionSubtopicViewModelImpl(message: message)
                    
                    try? expect(sut.message.toBlocking().first()).to(equal(message))
                }
            }
        }
    }
}
