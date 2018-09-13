//
//  MessageViewModelTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 04.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class MessageViewModelTests: BaseTestCase {
    override func spec() {
        describe("MessageViewModel") {
            describe("when create MessageViewModel", {
                context("and pass default parameters") {
                    it("should have valid proporties", closure: {
                        let sut = MessageViewModelImpl(title: "", description: "")
                        try? expect(sut.icon.toBlocking().first()).to(equal(Images.General.message))
                    })
                }
                context("and pass some parameters") {
                    it("should have valid proporties", closure: {
                        let title = String.random()
                        let description = String.random()
                        let icon = Images.Sections.newsSelected
                        
                        let sut = MessageViewModelImpl(title: title, description: description, icon: icon)
                        try? expect(sut.title.toBlocking().first()).to(equal(title))
                        try? expect(sut.description.toBlocking().first()).to(equal(description))
                        try? expect(sut.icon.toBlocking().first()).to(equal(icon))
                    })
                }
            })
        }
    }
}
