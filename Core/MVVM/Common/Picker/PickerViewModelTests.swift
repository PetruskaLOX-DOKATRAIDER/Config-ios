//
//  PickerViewModelTests.swift
//  Config
//
//  Created by Oleg Petrychuk on 25.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class PickerViewModelTests: BaseTestCase {
    override func spec() {
        describe("PickerViewModel") {
            var sut: PickerViewModelImpl<Int>!
            let items = [PickerItem(title: "1", object: 0), PickerItem(title: "2", object: 1), PickerItem(title: "3", object: 2)]
            
            beforeEach {
                sut = PickerViewModelImpl(items: items)
            }
            
            describe("when create PickerViewModel", {
                context("and pass some parameters") {
                    it("should have valid proporties", closure: {
                        let title = String.random()
                        let sut = PickerViewModelImpl(title: title, items: items)
                        try? expect(sut.title.toBlocking().first()).to(equal(title))
                        try? expect(sut.itemTitles.toBlocking().first()).to(equal(["1", "2", "3"]))
                    })
                }
            })
            
            describe("when item at index trigger", {
                context("with valid object index") {
                    it("should notify about object triggering", closure: {
                        let observer = self.scheduler.createObserver(PickerItem<Int>.self)
                        sut.itemPicked.drive(observer).disposed(by: self.disposeBag)
                        let index = items.count - 1
                        let expectedItem = items[safe: index]
                        sut.itemAtIndexTrigger.onNext(index)
                        try? expect(sut.itemPicked.map{ $0.title }.toBlocking().first()).to(equal(expectedItem?.title))
                        try? expect(sut.itemPicked.map{ $0.object }.toBlocking().first()).to(equal(expectedItem?.object))
                    })
                    
                    it("should ask to close", closure: {
                        let observer = self.scheduler.createObserver(Void.self)
                        sut.shouldClose.drive(observer).disposed(by: self.disposeBag)
                        sut.itemAtIndexTrigger.onNext(items.count - 1)
                        expect(observer.events.count).to(equal(1))
                    })
                }
                
                context("with invalid object index") {
                    it("shouldn't notify about date triggering", closure: {
                        let observer = self.scheduler.createObserver(PickerItem<Int>.self)
                        sut.itemPicked.drive(observer).disposed(by: self.disposeBag)
                        let index = items.count
                        sut.itemAtIndexTrigger.onNext(index)
                        expect(observer.events.count).to(equal(0))
                    })
                    
                    it("shouldn't ask to close", closure: {
                        let observer = self.scheduler.createObserver(Void.self)
                        sut.shouldClose.drive(observer).disposed(by: self.disposeBag)
                        let index = items.count
                        sut.itemAtIndexTrigger.onNext(index)
                        expect(observer.events.count).to(equal(0))
                    })
                }
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
