//
//  PaginatorTests.swift
//  Tests
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import XCTest
import Core
import RxTest
import RxBlocking
import Nimble

class PaginatorTests: BaseTestCase {
    func testElements() {
        let paginator: Paginator<String> = Paginator(factory: { (page) -> Observable<Page<String>> in
            .just(.new(content: ["\(page)a", "\(page)b"], index: page, totalPages: 3))
        })
        XCTAssert(paginator.elements.value.isEmpty)
        let observer = scheduler.createObserver([String].self)
        paginator.elements.asDriver().drive(observer).disposed(by: disposeBag)
        
        expect(observer.events.count).to(equal(1))
        expect(observer.events[0].time).to(equal(0))
        expect(observer.events[0].value.element).to(equal([]))
        
        paginator.refreshTrigger.onNext(())
        expect(observer.events.count).to(equal(2))
        expect(observer.events[1].value.element).to(equal(["1a", "1b"]))
        
        paginator.loadNextPageTrigger.accept(())
        expect(observer.events.count).to(equal(3))
        expect(observer.events[2].value.element).to(equal(["1a", "1b", "2a", "2b"]))
        
        paginator.loadNextPageTrigger.accept(())
        expect(observer.events.count).to(equal(4))
        expect(observer.events[3].value.element).to(equal(["1a", "1b", "2a", "2b", "3a", "3b"]))
    }
    
    func testIsWorking() {
        let paginator: Paginator<String> = Paginator(factory: { (_) -> Observable<Page<String>> in
            .just(.empty)
        })
        let observer = scheduler.createObserver(Bool.self)
        paginator.isWorking.drive(observer).disposed(by: disposeBag)
        paginator.refreshTrigger.onNext(())
        XCTAssertEqual(observer.events, [
            next(0, false),
            next(0, true),
            next(0, false)
        ])
    }
    
    func testEnabled() {
        let paginator: Paginator<String> = Paginator(factory: { (_) -> Observable<Page<String>> in
            .just(.empty)
        })
        let observer = scheduler.createObserver(Bool.self)
        paginator.isEnabled.asObservable().bind(to: observer).disposed(by: disposeBag)
        Observable.of(false, true).bind(to: paginator.isEnabled).disposed(by: disposeBag)
        XCTAssertEqual(observer.events, [
            next(0, true),
            next(0, false),
            next(0, true)
        ])
    }
    
    func testIsLoadedOnce() {
        let paginator: Paginator<String> = Paginator(factory: { (_) -> Observable<Page<String>> in
            .just(.empty)
        })
        let observer = scheduler.createObserver(Bool.self)
        paginator.isLoadedOnce.drive(observer).disposed(by: disposeBag)
        paginator.refreshTrigger.onNext(())
        XCTAssertEqual(observer.events, [
            next(0, false),
            next(0, true)
        ])
    }
    
    func testError() {
        let paginator: Paginator<String> = Paginator(factory: { (_) -> Observable<Page<String>> in
            .error(Errors.error)
        })
        let observer = scheduler.createObserver(Error.self)
        paginator.error.drive(observer).disposed(by: disposeBag)
        paginator.refreshTrigger.onNext(())
        XCTAssert(observer.events.first?.value.element is Errors)
        XCTAssert(observer.events.count == 1)
    }
    
    func testExcludeDuplicates() {
        let paginator: Paginator<String> = Paginator(factory: {
            .just(.new(content: ["a", "b", "c\($0)"], index: $0, totalPages: 2))
        }, accomulationStrategy: PaginationViewModelStrategies.Accomulations.excludeDuplicates)
        
        paginator.refreshTrigger.onNext(())
        paginator.loadNextPageTrigger.accept(())
        try expect(paginator.elements.asDriver().toBlocking().first()).to(equal(["a", "b", "c1", "c2"]))
    }
}

private enum Errors: Error {
    case error
}
