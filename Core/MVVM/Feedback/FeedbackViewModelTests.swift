//
//  FeedbackViewModelTests.swift
//  Config
//
//  Created by Oleg Petrychuk on 27.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class FeedbackViewModelTests: BaseTestCase {
    override func spec() {
        describe("FeedbackViewModel") {
            var analyticsService: AnalyticsServiceMock!
            var sut: FeedbackViewModel!
            
            beforeEach {
                analyticsService = AnalyticsServiceMock()
                sut = FeedbackViewModelImpl(analyticsService: analyticsService)
            }
            
            describe("when calling save did trigger") {
                
                context("and message is not empty") {
                    it("should track message") {
                        let text = String.random()
                        sut.messageTextFieldViewModel.text.accept(text)
                        
                        sut.sendTrigger.onNext(())
                        
                        expect(analyticsService.trackFeedbackWithMessageReceived).to(equal(text))
                    }
                    
                    it("should close") {
                        let observer = self.scheduler.createObserver(Void.self)
                        sut.shouldClose.drive(observer).disposed(by: self.disposeBag)
                        sut.messageTextFieldViewModel.text.accept(String.random())
                        
                        sut.sendTrigger.onNext(())
                        
                        expect(observer.events.count).to(equal(1))
                    }
                }
                
                context("and message is empty") {
                    it("shouldn't track message") {
                        sut.messageTextFieldViewModel.text.accept("")
                        
                        sut.sendTrigger.onNext(())
                        
                        expect(analyticsService.trackFeedbackWithMessageCalled).to(beFalsy())
                    }
                    
                    it("shouldn't close") {
                        let observer = self.scheduler.createObserver(Void.self)
                        sut.shouldClose.drive(observer).disposed(by: self.disposeBag)
                        sut.messageTextFieldViewModel.text.accept("")
                        
                        sut.sendTrigger.onNext(())
                        
                        expect(observer.events.count).to(equal(0))
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
        }
    }
}
