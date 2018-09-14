//
//  NewsViewModelTests.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class NewsViewModelTests: BaseTestCase {
    override func spec() {
        describe("NewsViewModel") {
            let newsService = NewsServiceMock()
            var sut: NewsViewModel!
            
            beforeEach {
                sut = NewsViewModelImpl(newsService: newsService)
            }
            
            describe("when calling refresh did trigger") {
                context("and retrieving data") {
                    let news1 = NewsPreview.new(
                        title: String.random(),
                        coverImageURL: URL.new(),
                        detailsURL: URL.new(),
                        id: Int.random()
                    )
                    let news2 = NewsPreview.new(
                        title: String.random(),
                        coverImageURL: nil,
                        detailsURL: nil,
                        id: Int.random()
                    )
                    let content = [news1, news2]
                    
                    beforeEach {
                        newsService.getPreviewPageReturnValue = .just(Result(value: Page.new(content: content, index: 0, totalPages: 0)))
                    }
                    
                    it("should return news") {
                        sut.newsPaginator.refreshTrigger.onNext(())
                        try? expect(sut.newsPaginator.elements.toBlocking().first()?.count).to(equal(content.count))
                        try? expect(sut.newsPaginator.elements.toBlocking().first()?.first?.title.toBlocking().first()).to(equal(news1.title))
                        try? expect(sut.newsPaginator.elements.toBlocking().first()?.first?.coverImage.filterNil().toBlocking().first()).to(equal(news1.coverImageURL))
                        try? expect(sut.newsPaginator.elements.toBlocking().first()?.last?.title.toBlocking().first()).to(equal(news2.title))
                        try? expect(sut.newsPaginator.elements.toBlocking().first()?.last?.coverImage.filterNil().toBlocking().first()).to(beNil())
                    }
                    
                    describe("when calling news did trigger") {
                        it("should route to valid news description") {
                            let observer = self.scheduler.createObserver(NewsPreview.self)
                            sut.shouldRouteDescription.drive(observer).disposed(by: self.disposeBag)
                            sut.newsPaginator.refreshTrigger.onNext(())
                            let playerItemVM = try? sut.newsPaginator.elements.toBlocking().first()?.first
                            
                            playerItemVM??.selectionTrigger.onNext(())
                            
                            try? expect(sut.shouldRouteDescription.map{ $0.id }.toBlocking().first()).to(equal(news1.id))
                        }
                    }
                    
                    describe("when calling share news did trigger") {
                        context("and details URL is exist") {
                            it("should share news URL") {
                                let observer = self.scheduler.createObserver(ShareItem.self)
                                sut.shouldShare.drive(observer).disposed(by: self.disposeBag)
                                sut.newsPaginator.refreshTrigger.onNext(())
                                let playerItemVM = try? sut.newsPaginator.elements.toBlocking().first()?.first
                                
                                playerItemVM??.shareTrigger.onNext(())
                                
                                try? expect(sut.shouldShare.map{ $0.url }.filterNil().toBlocking().first()).to(equal(news1.detailsURL))
                            }
                        }
                        context("and details URL is not exist") {
                            it("shouldn't share"){
                                let observer = self.scheduler.createObserver(ShareItem.self)
                                sut.shouldShare.drive(observer).disposed(by: self.disposeBag)
                                sut.newsPaginator.refreshTrigger.onNext(())
                                let playerItemVM = try? sut.newsPaginator.elements.toBlocking().first()?.last
                                
                                playerItemVM??.shareTrigger.onNext(())
                                
                                expect(observer.events.count).to(equal(0))
                            }
                        }
                    }
                }
                
                context("and retrieving error") {
                    beforeEach {
                        newsService.getPreviewPageReturnValue = .just(Result(error: .unknown))
                    }
  
                    it("should show error message") {
                        let observer = self.scheduler.createObserver(MessageViewModel.self)
                        sut.messageViewModel.drive(observer).disposed(by: self.disposeBag)
                        
                        sut.newsPaginator.refreshTrigger.onNext(())
                        
                        let messageVM = try? sut.messageViewModel.toBlocking().first()
                        try? expect(messageVM??.title.toBlocking(timeout: 1).first()).to(equal(Strings.Errors.error))
                    }
                }
            }
            
            describe("when calling profile did trigger") {
                it("should route to profile") {
                    let observer = self.scheduler.createObserver(Void.self)
                    sut.shouldRouteProfile.drive(observer).disposed(by: self.disposeBag)
                    
                    sut.profileTrigger.onNext(())
                    
                    expect(observer.events.count).to(equal(1))
                }
            }
        }
    }
}
