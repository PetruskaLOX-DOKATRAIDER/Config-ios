//
//  DatePickerViewModelTests.swift
//  Config
//
//  Created by Oleg Petrychuk on 25.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class DatePickerViewModelTests: BaseTestCase {
    override func spec() {
        describe("DatePickerViewModel") {
            var sut: DatePickerViewModel!
            
            beforeEach {
                sut = DatePickerViewModelImpl()
            }
            
            describe("when create DatePickerViewModel", {
                context("and pass some parameters") {
                    it("should have valid proporties", closure: {
                        let title = String.random()
                        let minimumDate = Date.random()
                        let maximumDate = Date.random()
                        
                        let sut = DatePickerViewModelImpl(title: title, minimumDate: minimumDate, maximumDate: maximumDate)
                        try? expect(sut.title.toBlocking().first()).to(equal(title))
                        try? expect(sut.minimumDate.filterNil().toBlocking().first()).to(equal(minimumDate))
                        try? expect(sut.maximumDate.filterNil().toBlocking().first()).to(equal(maximumDate))
                    })
                }
            })
            
            describe("when date trigger", {
                it("should notify about date triggering", closure: {
                    let observer = self.scheduler.createObserver(Date.self)
                    sut.datePicked.drive(observer).disposed(by: self.disposeBag)
                    let date = Date.random()
                    sut.dateTrigger.onNext(date)
                    try? expect(sut.datePicked.toBlocking().first()).to(equal(date))
                })
                
                it("should ask to close", closure: {
                    let observer = self.scheduler.createObserver(Void.self)
                    sut.shouldClose.drive(observer).disposed(by: self.disposeBag)
                    sut.dateTrigger.onNext(Date.random())
                    expect(observer.events.count).to(equal(1))
                })
            })
            
            describe("when close trigger", {
                it("should ask to close", closure: {
                    let observer = self.scheduler.createObserver(Void.self)
                    sut.shouldClose.drive(observer).disposed(by: self.disposeBag)
                    sut.closeTrigger.onNext(())
                    expect(observer.events.count).to(equal(1))
                })
            })
        }
    }
}
