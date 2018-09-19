//
//  NewsImageContentItemViewModelTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 19.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class NewsImageContentItemViewModelTests: BaseTestCase {
    override func spec() {
        describe("NewsImageContentItemViewModel") {
            describe("when ask image") {
                it("should have valid image") {
                    let newsImageContent = NewsImageContent.new(coverImageURL: URL.new())
                    
                    let sut = NewsImageContentItemViewModelImpl(newsImageContent: newsImageContent)
                    
                    try? expect(sut.coverImageURL.filterNil().toBlocking().first()).to(equal(newsImageContent.coverImageURL))
                }
            }
        }
    }
}
