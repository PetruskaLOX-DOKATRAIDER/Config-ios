//
//  NewsTextContentItemViewModelTests.swift
//  Tests
//
//  Created by Oleg Petrychuk on 19.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class NewsTextContentItemViewModelTests: BaseTestCase {
    override func spec() {
        describe("NewsTextContentItemViewModel") {
            describe("when ask text") {
                it("should have valid text") {
                    let newsTextContent = NewsTextContent.new(text: String.random())
                    
                    let sut = NewsTextContentItemViewModelImpl(newsTextContent: newsTextContent)
                    
                    try? expect(sut.text.toBlocking().first()).to(equal(newsTextContent.text))
                }
            }
        }
    }
}
