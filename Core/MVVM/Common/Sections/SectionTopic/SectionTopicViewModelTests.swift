//
//  SectionTopicViewModelTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 13.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class SectionTopicViewModelTests: BaseTestCase {
    override func spec() {
        describe("SectionTopicViewModel") {
            describe("when create SectionTopicViewModel", {
                context("and pass default parameters") {
                    it("should have valid proporties", closure: {
                        let sut = SectionTopicViewModelImpl()
                        try? expect(sut.title.toBlocking().first()).to(beEmpty())
                        try? expect(sut.icon.filterNil().toBlocking().first()).to(beNil())
                    })
                }
                context("and pass some parameters") {
                    it("should have valid proporties", closure: {
                        let title = String.random()
                        let icon = Images.Sections.newsSelected
                        
                        let sut = SectionTopicViewModelImpl(title: title, icon: icon)
                        try? expect(sut.title.toBlocking().first()).to(equal(title))
                        try? expect(sut.icon.filterNil().toBlocking().first()).to(equal(icon))
                    })
                }
            })
        }
    }
}
