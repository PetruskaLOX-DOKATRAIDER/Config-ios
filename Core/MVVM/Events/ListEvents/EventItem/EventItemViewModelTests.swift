//
//  EventItemViewModelTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class EventItemViewModelTests: BaseTestCase {
    override func spec() {
        describe("EventItemViewModel") {
            describe("when ask proporties") {
                it("should have valid properties") {
                    let event = Event.new(
                        name: String.random(),
                        city: String.random(),
                        flagURL: nil,
                        detailsURL: nil,
                        startDate: Date(timeIntervalSince1970: 1536764817), // 12.09.2018,
                        finishDate: Date(timeIntervalSince1970: 1536764917), // 12.09.2018,
                        logoURL: URL.new(),
                        prizePool: 2000,
                        countOfTeams: 10,
                        coordinates: Coordinates.new(lat: Double.random(), lng: Double.random())
                    )
                    
                    let sut = EventItemViewModelImpl(event: event)
                    
                    try? expect(sut.name.toBlocking().first()).to(equal(event.name))
                    try? expect(sut.city.toBlocking().first()).to(equal(event.city))
                    try? expect(sut.logoURL.filterNil().toBlocking().first()).to(equal(event.logoURL))
                    try? expect(sut.flagURL.filterNil().toBlocking().first()).to(beNil())
                    try? expect(sut.description.map{ $0.full }.toBlocking().first()).to(equal(Strings.ListEvents.description("12.09.2018", "12.09.2018", 10, "2000.000$")))
                    try? expect(sut.description.map{ $0.highlights }.toBlocking().first()).to(equal(["10", "2000.000$", "12.09.2018", "12.09.2018"]))
                }
            }
        }
    }
}
