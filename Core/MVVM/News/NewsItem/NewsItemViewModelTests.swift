//
//  NewsItemViewModelTests.swift
//  Config
//
//  Created by Oleg Petrychuk on 31.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class NewsItemViewModelTests: BaseTestCase {
    override func spec() {
        describe("NewsItemViewModel") {
            describe("when ask proporties") {
                it("should have valid properties") {
                    let news = NewsPreview.new(
                        title: String.random(),
                        coverImageURL: URL.new(),
                        detailsURL: nil,
                        id: 0
                    )
                    let sut = NewsItemViewModelImpl(news: news)
                    
                    try? expect(sut.title.toBlocking().first()).to(equal(news.title))
                    try? expect(sut.coverImage.filterNil().toBlocking().first()).to(equal(news.coverImageURL))
                }
            }
        }
    }
}
