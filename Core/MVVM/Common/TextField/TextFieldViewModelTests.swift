//
//  TextFieldViewModelTests.swift
//  Tests
//
//  Created by Oleg Petrychuk on 13.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class TextFieldViewModelTests: BaseTestCase {
    override func spec() {
        describe("SectionTopicViewModel") {
            describe("when ask proporties") {
                it("should return valid proporties") {
                    let text = String.random()
                    let placeholder = String.random()
                    let sut = TextFieldViewModelImpl(text: text, placeholder: placeholder)
                    try? expect(sut.text.toBlocking().first()).to(equal(text))
                    try? expect(sut.placeholder.toBlocking().first()).to(equal(placeholder))
                }
            }
            
            describe("when calling text did change") {
                it("should store passed text") {
                    let text = String.random()
                    let textField = UITextField()
                    let sut = TextFieldViewModelImpl(text: "")
                    textField.viewModel = sut
                    textField.text = text
                    
                    textField.sendActions(for: .valueChanged)
                    
                    try? expect(sut.text.asDriver().toBlocking().first()).to(equal(text))
                }
            }
        }
    }
}
