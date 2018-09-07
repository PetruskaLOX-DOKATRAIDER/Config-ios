//
//  ActivityTrackerTests.swift
//  Tests
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import XCTest
import TestsHelper
import Core
import RxTest

class ActivityTrackerTests: BaseTestCase {
    func testTracking() {
        let scheduler = TestScheduler(initialClock: 0)
        let tracker = ActivityTracker()
        let observer = scheduler.createObserver(Bool.self)
        
        let observable1 = scheduler.createHotObservable([
            next(10, 0),
            next(20, 1),
            completed(30)
        ])
        
        let observable2 = scheduler.createHotObservable([
            next(20, 0),
            next(30, 1),
            completed(40)
        ])
        
        let observable3 = scheduler.createHotObservable([
            next(50, 0),
            next(60, 1),
            completed(70)
        ])
        
        tracker.asSharedSequence().drive(observer).disposed(by: disposeBag)
        
        observable1.trackBy(tracker).delaySubscription(10, scheduler: scheduler).subscribe().disposed(by: disposeBag)
        observable2.trackBy(tracker).delaySubscription(20, scheduler: scheduler).subscribe().disposed(by: disposeBag)
        observable3.trackBy(tracker).delaySubscription(50, scheduler: scheduler).subscribe().disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(observer.events, [
            next(0, false),
            next(10, true),
            next(40, false),
            next(50, true),
            next(70, false)
        ])
    }
}
