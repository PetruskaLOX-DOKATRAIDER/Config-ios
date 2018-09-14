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
            
            describe("when ask proporties") {
                it("should return valid proporties") {
                    let title = String.random()
                    let minimumDate = Date.random()
                    let maximumDate = Date.random()
                    
                    let sut = DatePickerViewModelImpl(title: title, minimumDate: minimumDate, maximumDate: maximumDate)
                    
                    try? expect(sut.title.toBlocking().first()).to(equal(title))
                    try? expect(sut.minimumDate.filterNil().toBlocking().first()).to(equal(minimumDate))
                    try? expect(sut.maximumDate.filterNil().toBlocking().first()).to(equal(maximumDate))
                }
            }
            
            describe("when calling date did trigger") {
                it("should notify abot date did picked") {
                    let observer = self.scheduler.createObserver(Date.self)
                    sut.datePicked.drive(observer).disposed(by: self.disposeBag)
                    let date = Date.random()
                    
                    sut.dateTrigger.onNext(date)
                    
                    try? expect(sut.datePicked.toBlocking().first()).to(equal(date))
                }
                
                it("should notify about close") {
                    let observer = self.scheduler.createObserver(Void.self)
                    sut.shouldClose.drive(observer).disposed(by: self.disposeBag)
                    
                    sut.dateTrigger.onNext(Date.random())
                    
                    expect(observer.events.count).to(equal(1))
                }
            }
            
            describe("when calling close did trigger") {
                it("should notify about close") {
                    let observer = self.scheduler.createObserver(Void.self)
                    sut.shouldClose.drive(observer).disposed(by: self.disposeBag)
                    
                    sut.closeTrigger.onNext(())
                    
                    expect(observer.events.count).to(equal(1))
                }
            }
        }
    }
}
