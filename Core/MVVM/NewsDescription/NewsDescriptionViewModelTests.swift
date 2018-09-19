//
//  NewsDescriptionViewModelTests.swift
//  Config
//
//  Created by Oleg Petrychuk on 01.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class NewsDescriptionViewModelTests: BaseTestCase {
    override func spec() {
        describe("NewsDescriptionViewModel") {
            let newsPreview = NewsPreview.new(
                title: String.random(),
                coverImageURL: URL.new(),
                detailsURL: URL.new(), id:
                Int.random()
            )
            let newsContent1 = NewsImageContent.new(coverImageURL: URL.new())
            let newsContent2 = NewsTextContent.new(text: String.random())
            let newsContent3 = NewsImageContent.new(coverImageURL: URL.new())
            let newsDescription = NewsDescription.new(
                title: String.random(),
                date: Date(timeIntervalSince1970: 1537365251), // 19.09.2018
                author: String.random(),
                moreInfoURL: URL.new(),
                id: Int.random(),
                content: [newsContent1, newsContent2, newsContent3]
            )
            
            let newsService = NewsServiceMock()
            var sut: NewsDescriptionViewModel!
            
            beforeEach {
                sut = NewsDescriptionViewModelImpl(news: newsPreview, newsService: newsService)
            }
            
            describe("when refresh did trigger") {
                context("and received data") {
                    it("should have valid properties") {
                        let titleObserver = self.scheduler.createObserver(String.self)
                        sut.title.drive(titleObserver).disposed(by: self.disposeBag)
                        let subtitleObserver = self.scheduler.createObserver(String.self)
                        sut.subtitle.drive(subtitleObserver).disposed(by: self.disposeBag)
                        let descriptioneObserver = self.scheduler.createObserver(String.self)
                        sut.description.drive(descriptioneObserver).disposed(by: self.disposeBag)
                        let coverImageObserver = self.scheduler.createObserver(URL?.self)
                        sut.coverImageURL.drive(coverImageObserver).disposed(by: self.disposeBag)
                        let contentObserver = self.scheduler.createObserver([NewsContentItemViewModel].self)
                        sut.content.drive(contentObserver).disposed(by: self.disposeBag)
                        let isWorkingObserver = self.scheduler.createObserver(Bool.self)
                        sut.isWorking.drive(isWorkingObserver).disposed(by: self.disposeBag)
                        let isDataAvaliableObserver = self.scheduler.createObserver(Bool.self)
                        sut.isDataAvaliable.drive(isDataAvaliableObserver).disposed(by: self.disposeBag)
                        newsService.getDescriptionNewsReturnValue = .just(Result(value: newsDescription))
                        
                        sut.refreshTrigger.onNext(())

                        let expectDescription = "\(Strings.Newsdescription.posted) 19.09.2018 \(Strings.Newsdescription.by) \(newsDescription.author)"
                        try? expect(sut.title.toBlocking().first()).toEventually(equal(newsPreview.title), timeout: 0.1)
                        try? expect(sut.subtitle.toBlocking().first()).toEventually(equal(newsDescription.title), timeout: 0.1)
                        try? expect(sut.description.toBlocking().first()).toEventually(equal(expectDescription), timeout: 0.1)
                        try? expect(sut.coverImageURL.filterNil().toBlocking().first()).toEventually(equal(newsPreview.coverImageURL), timeout: 0.1)
                        try? expect(sut.content.toBlocking().first()?.count).toEventually(equal(newsDescription.content.count), timeout: 0.1)
                        try? expect(sut.content.toBlocking().first()?[safe: 0]).toEventually(beAKindOf(NewsImageContentItemViewModel.self))
                        try? expect(sut.content.toBlocking().first()?[safe: 1]).toEventually(beAKindOf(NewsTextContentItemViewModel.self))
                        try? expect(sut.content.toBlocking().first()?[safe: 2]).toEventually(beAKindOf(NewsImageContentItemViewModel.self))
                        try? expect(sut.isWorking.toBlocking().first()).toEventually((beFalsy()), timeout: 0.1)
                        try? expect(sut.isDataAvaliable.toBlocking().first()).toEventually((beTruthy()), timeout: 0.1)
                    }
                }
                
                context("and received error") {
                    it("should have valid properties") {
                        let isWorkingObserver = self.scheduler.createObserver(Bool.self)
                        sut.isWorking.drive(isWorkingObserver).disposed(by: self.disposeBag)
                        let isDataAvaliableObserver = self.scheduler.createObserver(Bool.self)
                        sut.isDataAvaliable.drive(isDataAvaliableObserver).disposed(by: self.disposeBag)
                        newsService.getDescriptionNewsReturnValue = .just(Result(error: .unknown))
                        
                        sut.refreshTrigger.onNext(())
                        
                        try? expect(sut.isWorking.toBlocking().first()).toEventually((beFalsy()), timeout: 0.1)
                        try? expect(sut.isDataAvaliable.toBlocking().first()).toEventually((beFalsy()), timeout: 0.1)
                    }
                    
                    it("show error message") {
                        let observer = self.scheduler.createObserver(MessageViewModel.self)
                        sut.messageViewModel.drive(observer).disposed(by: self.disposeBag)
                        newsService.getDescriptionNewsReturnValue = .just(Result(error: .unknown))

                        sut.refreshTrigger.onNext(())

                        expect(observer.events.count).toEventually(equal(1), timeout: 0.1)
                    }
                }
            }
            
            describe("when refresh did trigger") {
                 context("and received data") {
                    describe("and image in content calling did trigger") {
                        it("should router to image viewer") {
                            let contentObserver = self.scheduler.createObserver([NewsContentItemViewModel].self)
                            sut.content.drive(contentObserver).disposed(by: self.disposeBag)
                            let observer = self.scheduler.createObserver(URL.self)
                            sut.shouldRouteImageViewer.drive(observer).disposed(by: self.disposeBag)
                            newsService.getDescriptionNewsReturnValue = .just(Result(value: newsDescription))

                            sut.refreshTrigger.onNext(())

                            let imageItemVM = (try? sut.content.toBlocking().first()?.first) as? NewsImageContentItemViewModel
                            imageItemVM?.selectionTrigger.onNext(())

                            try? expect(sut.shouldRouteImageViewer.toBlocking().first()).to(equal(newsContent1.coverImageURL))
                        }
                    }
                }
            }
            
            describe("when calling close did trigger") {
                it("should close") {
                    let observer = self.scheduler.createObserver(Void.self)
                    sut.shouldClose.drive(observer).disposed(by: self.disposeBag)

                    sut.closeTrigger.onNext(())

                    expect(observer.events.count).to(equal(1))
                }
            }
            
            describe("when calling share did trigger") {
                it("should share passed image") {
                    let observer = self.scheduler.createObserver(ShareItem.self)
                    sut.shouldShare.drive(observer).disposed(by: self.disposeBag)

                    sut.shareTrigger.onNext(())

                    try? expect(sut.shouldShare.map{ $0.url }.filterNil().toBlocking().first()).to(equal(newsPreview.detailsURL))
                }
            }
        }
    }
}
