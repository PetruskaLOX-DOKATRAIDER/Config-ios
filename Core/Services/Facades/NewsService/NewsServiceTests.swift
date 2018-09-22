//
//  NewsServiceTests.swift
//  Core
//
//  Created by Петрічук Олег Аркадійовіч on 22.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class NewsServiceTests: BaseTestCase {
    override func spec() {
        describe("NewsService") {
            let newsPreview1 = NewsPreview.new(title: String.random(), coverImageURL: URL.new(), detailsURL: URL.new(), id: Int.random())
            let newsPreview2 = NewsPreview.new(title: String.random(), coverImageURL: URL.new(), detailsURL: URL.new(), id: Int.random())
            let newsContent = NewsTextContent.new(text: String.random())
            let newsDescription = NewsDescription.new(title: String.random(), date: Date.random(), author: String.random(), moreInfoURL: URL.new(), id: Int.random(), content: [newsContent])
            
            let reachabilityService = ReachabilityServiceMock(connection: .cellular)
            var newsStorage: NewsStorageMock!
            var newsAPIService: NewsAPIServiceMock!
            var sut: NewsService!
            
            beforeEach {
                newsStorage = NewsStorageMock()
                newsStorage.updatePreviewWithNewReturnValue = .just(())
                newsStorage.updateDescriptionWithNewReturnValue = .just(())
                newsAPIService = NewsAPIServiceMock()
                sut = NewsServiceImpl(reachabilityService: reachabilityService, newsAPIService: newsAPIService, newsStorage: newsStorage)
            }
            
            describe("when ask news preview") {
                context("and there is no internet connection") {
                    it("should return news preview from the storage") {
                        reachabilityService.connection = .none
                        newsStorage.getPreviewReturnValue = .just([newsPreview1, newsPreview2])
                        
                        expect(newsAPIService.getPageCalled).to(beFalsy())
                        try? expect(sut.getPreview(page: 1).success().toBlocking().first()?.content.count).to(equal(2))
                        try? expect(sut.getPreview(page: 1).success().toBlocking().first()?.content.first?.id).to(equal(newsPreview1.id))
                        try? expect(sut.getPreview(page: 1).success().toBlocking().first()?.content.last?.id).to(equal(newsPreview2.id))
                    }
                }
                
                context("and there is internet connection") {
                    context("and API returned data") {
                        it("should return received data") {
                            reachabilityService.connection = .wifi
                            let page = Page.new(content: [newsPreview1, newsPreview2], index: Int.random(), totalPages: Int.random())
                            newsAPIService.getPageReturnValue = .just(Result(value: page))

                            expect(newsStorage.getPreviewCalled).to(beFalsy())
                            try? expect(sut.getPreview(page: 1).success().toBlocking().first()?.content.count).to(equal(page.content.count))
                            try? expect(sut.getPreview(page: 1).success().toBlocking().first()?.content.first?.id).to(equal(newsPreview1.id))
                            try? expect(sut.getPreview(page: 1).success().toBlocking().first()?.content.last?.id).to(equal(newsPreview2.id))
                        }
                        it("should ask storage to update data") {
                            reachabilityService.connection = .wifi
                            let page = Page.new(content: [newsPreview1, newsPreview2], index: Int.random(), totalPages: Int.random())
                            newsAPIService.getPageReturnValue = .just(Result(value: page))

                            _ = try? sut.getPreview(page: 1).toBlocking().first()
                            
                            expect(newsStorage.updatePreviewWithNewReceived?.count).to(equal(page.content.count))
                            expect(newsStorage.updatePreviewWithNewReceived?.first?.id).to(equal(newsPreview1.id))
                            expect(newsStorage.updatePreviewWithNewReceived?.last?.id).to(equal(newsPreview2.id))
                        }
                    }
                    
                    context("and API returned error") {
                        it("should return error") {
                            reachabilityService.connection = .wifi
                            newsAPIService.getPageReturnValue = .just(.init(error: .init(key: "", value: "")))

                            try? expect(sut.getPreview(page: 1).failure().toBlocking().first()).to(equal(NewsServiceError.serverError("")))
                        }
                    }
                }
            }
            
            describe("when ask news description") {
                context("and there is no internet connection") {
                    it("should return news description from the storage") {
                        reachabilityService.connection = .none
                        newsStorage.getDescriptionNewsReturnValue = .just(newsDescription)
                        
                        expect(newsAPIService.getNewsCalled).to(beFalsy())
                        try? expect(sut.getDescription(news: 1).success().toBlocking().first()?.id).to(equal(newsDescription.id))
                        try? expect(sut.getDescription(news: 1).success().toBlocking().first()?.title).to(equal(newsDescription.title))
                        try? expect(sut.getDescription(news: 1).success().toBlocking().first()?.content.count).to(equal(newsDescription.content.count))
                    }
                }
                
                context("and there is internet connection") {
                    context("and API returned data") {
                        it("should return received data") {
                            reachabilityService.connection = .wifi
                            newsAPIService.getNewsReturnValue = .just(Result(value: newsDescription))
                            
                            expect(newsStorage.getDescriptionNewsCalled).to(beFalsy())
                            try? expect(sut.getDescription(news: 1).success().toBlocking().first()?.id).to(equal(newsDescription.id))
                            try? expect(sut.getDescription(news: 1).success().toBlocking().first()?.title).to(equal(newsDescription.title))
                            try? expect(sut.getDescription(news: 1).success().toBlocking().first()?.content.count).to(equal(newsDescription.content.count))
                        }
                        it("should ask storage to update data") {
                            reachabilityService.connection = .wifi
                            newsAPIService.getNewsReturnValue = .just(Result(value: newsDescription))
                            
                            _ = try? sut.getDescription(news: 1).success().toBlocking().first()
                            
                            expect(newsStorage.updateDescriptionWithNewReceived?.id).to(equal(newsDescription.id))
                            expect(newsStorage.updateDescriptionWithNewReceived?.title).to(equal(newsDescription.title))
                            expect(newsStorage.updateDescriptionWithNewReceived?.content.count).to(equal(newsDescription.content.count))
                        }
                    }
                    
                    context("and API returned error") {
                        it("should return error") {
                            reachabilityService.connection = .wifi
                            newsAPIService.getNewsReturnValue = .just(.init(error: .init(key: "", value: "")))
                            
                            try? expect(sut.getDescription(news: 1).failure().toBlocking().first()).to(equal(NewsServiceError.serverError("")))
                        }
                    }
                }
            }
        }
    }
}
