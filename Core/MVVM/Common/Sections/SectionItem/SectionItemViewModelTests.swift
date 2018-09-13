//
//  SectionItemViewModelTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 13.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class SectionItemViewModelTests: BaseTestCase {
    override func spec() {
        describe("SectionItemViewModel") {
            describe("when create SectionItemViewModel", {
                context("and pass default parameters") {
                    it("should have valid proporties", closure: {
                        let sut = SectionItemViewModelImpl(title: "")
                        try? expect(sut.icon.filterNil().toBlocking().first()).to(beNil())
                        try? expect(sut.withDetail.toBlocking().first()).to(beTruthy())
                    })
                }
                context("and pass some parameters") {
                    it("should have valid proporties", closure: {
                        let title = String.random()
                        let withDetail = Bool.random()
                        
                        let sut = SectionItemViewModelImpl(title: title, icon: nil, withDetail: withDetail)
                        try? expect(sut.icon.filterNil().toBlocking().first()).to(beNil())
                        try? expect(sut.title.toBlocking().first()).to(equal(title))
                        try? expect(sut.withDetail.toBlocking().first()).to(equal(withDetail))
                    })
                }
            })
        }
    }
}
