//
//  ListEventsViewModelTests.swift
//  Config
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class ListEventsViewModelTests: BaseTestCase {
    override func spec() {
        describe("ListEventsViewModel") {
            let event1 = Event.new(
                name: String.random(),
                city: String.random(),
                flagURL: nil,
                detailsURL: URL.new(),
                startDate: Date.new(),
                finishDate: Date.new(),
                logoURL: URL.new(),
                prizePool: Double.new(),
                countOfTeams: Int.random(),
                coordinates: Coordinates.new(lat: Double.new(), lng: Double.new())
            )
            let event2 = Event.new(
                name: String.random(),
                city: String.random(),
                flagURL: nil,
                detailsURL: URL.new(),
                startDate: Date.new(),
                finishDate: Date.new(),
                logoURL: URL.new(),
                prizePool: Double.new(),
                countOfTeams: Int.random(),
                coordinates: Coordinates.new(lat: Double.new(), lng: Double.new())
            )
            let page = Page.new(content: [event1, event2], index: 1, totalPages: 1)
            let eventsPaginator = Paginator(factory: { _ in return Observable.just(page) })
            eventsPaginator.elements.accept([event1, event2])
            let sut = ListEventsViewModelImpl(events: eventsPaginator)
            
            describe("when ask events") {
                it("should return valid events") {
                    try? expect(sut.events.toBlocking().first()?.count).to(equal(page.content.count))
                    try? expect(sut.events.toBlocking().first()?.first?.name.toBlocking().first()).to(equal(event1.name))
                    try? expect(sut.events.toBlocking().first()?.last?.name.toBlocking().first()).to(equal(event2.name))
                }
            }
            
            describe("when calling event did trigger") {
                it("should open valid url") {
                    let observer = self.scheduler.createObserver(URL.self)
                    sut.shouldOpenURL.drive(observer).disposed(by: self.disposeBag)
                    let eventItemVM = try? sut.events.toBlocking().first()?.last
                   
                    eventItemVM??.selectionTrigger.onNext(())
                    
                    try? expect(sut.shouldOpenURL.toBlocking().first()).to(equal(event2.detailsURL))
                }
            }
        }
    }
}
