//
//  EventsServiceTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 22.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class EventsServiceTests: BaseTestCase {
    override func spec() {
        describe("EventsService") {
            let event1 = Event.new(name: String.random(), city: String.random(), flagURL: URL.new(), detailsURL: URL.new(), startDate: Date.new(), finishDate: Date.new(), logoURL: URL.new(), prizePool: Double.random(), countOfTeams: Int.random(), coordinates: Coordinates.new(lat: Double.new(), lng: Double.new()))
            let event2 = Event.new(name: String.random(), city: String.random(), flagURL: URL.new(), detailsURL: URL.new(), startDate: Date.new(), finishDate: Date.new(), logoURL: URL.new(), prizePool: Double.random(), countOfTeams: Int.random(), coordinates: Coordinates.new(lat: Double.new(), lng: Double.new()))
            let reachabilityService = ReachabilityServiceMock(connection: .cellular)
            var eventsStorage: EventsStorageMock!
            var eventsAPIService: EventsAPIServiceMock!
            var eventsFiltersStorage: EventsFiltersStorageMock!
            var sut: EventsService!
            
            beforeEach {
                eventsStorage = EventsStorageMock()
                eventsStorage.updateWithNewReturnValue = .just(())
                eventsAPIService = EventsAPIServiceMock()
                eventsFiltersStorage = EventsFiltersStorageMock(startDate: BehaviorRelay(value: nil), finishDate: BehaviorRelay(value: nil), maxCountOfTeams: BehaviorRelay(value: nil), minPrizePool: BehaviorRelay(value: -1))
                sut = EventsServiceImpl(reachabilityService: reachabilityService, eventsAPIService: eventsAPIService, eventsStorage: eventsStorage, eventsFiltersStorage: eventsFiltersStorage)
            }
            
            describe("when ask events") {
                context("and filters are empty") {
                    context("and there is no internet connection") {
                        it("should return teams from the storage") {
                            reachabilityService.connection = .none
                            eventsStorage.getReturnValue = .just([event1, event2])
                            
                            try? expect(sut.get(page: 1).success().toBlocking().first()?.content.count).to(equal(2))
                            try? expect(sut.get(page: 1).success().toBlocking().first()?.content.first?.name).to(equal(event1.name))
                            try? expect(sut.get(page: 1).success().toBlocking().first()?.content.last?.name).to(equal(event2.name))
                            expect(eventsAPIService.getPageCalled).to(beFalsy())
                        }
                    }
                    
                    context("and there is internet connection") {
                        context("and API returned data") {
                            it("should return received data") {
                                reachabilityService.connection = .wifi
                                let page = Page.new(content: [event1, event2], index: Int.random(), totalPages: Int.random())
                                eventsAPIService.getPageReturnValue = .just(Result(value: page))
                                
                                try? expect(sut.get(page: 1).success().toBlocking().first()?.content.count).to(equal(page.content.count))
                                try? expect(sut.get(page: 1).success().toBlocking().first()?.content.first?.name).to(equal(event1.name))
                                try? expect(sut.get(page: 1).success().toBlocking().first()?.content.last?.name).to(equal(event2.name))
                                expect(eventsStorage.getCalled).to(beFalsy())
                            }
                            it("should ask storage to update data") {
                                reachabilityService.connection = .wifi
                                let page = Page.new(content: [event1, event2], index: Int.random(), totalPages: Int.random())
                                eventsAPIService.getPageReturnValue = .just(Result(value: page))
                                
                                _ = try? sut.get(page: 1).toBlocking().first()
                                
                                expect(eventsStorage.updateWithNewReceived?.count).to(equal(page.content.count))
                                expect(eventsStorage.updateWithNewReceived?.first?.name).to(equal(event1.name))
                                expect(eventsStorage.updateWithNewReceived?.last?.name).to(equal(event2.name))
                            }
                        }
                        
                        context("and API returned error") {
                            it("should return error") {
                                reachabilityService.connection = .wifi
                                eventsAPIService.getPageReturnValue = .just(.init(error: .init(key: "", value: "")))
                                
                                try? expect(sut.get(page: 1).failure().toBlocking().first()).to(equal(EventsServiceError.serverError("")))
                            }
                        }
                    }
                }
                context("and filters are not empty") {
                    func cleanFilters() {
                        eventsFiltersStorage.startDate.accept(nil)
                        eventsFiltersStorage.finishDate.accept(nil)
                        eventsFiltersStorage.minPrizePool.accept(nil)
                        eventsFiltersStorage.maxCountOfTeams.accept(nil)
                    }
                    
                    context("when event too early") {
                        it("shouldn't return this event") {
                            let today = Date()
                            let tomorrow = Calendar.current.date(byAdding: .day, value: -1, to: today) ?? today
                            let event = Event.new(name: "", city: "", flagURL: nil, detailsURL: nil, startDate: tomorrow, finishDate: Date.new(), logoURL: nil, prizePool: Double.random(), countOfTeams: Int.random(), coordinates: Coordinates.new(lat: 1, lng: 1))
                            reachabilityService.connection = .wifi
                            eventsAPIService.getPageReturnValue = .just(Result(value: Page.new(content: [event], index: 1, totalPages: 1)))
                            cleanFilters()
                            eventsFiltersStorage.startDate.accept(today)
                            
                            try? expect(sut.get(page: 1).success().toBlocking().first()?.content.count).to(equal(0))
                        }
                    }
                    
                    context("when event too late") {
                        it("shouldn't return this event") {
                            let today = Date()
                            let tomorrow = Calendar.current.date(byAdding: .day, value: -2, to: today) ?? today
                            let event = Event.new(name: "", city: "", flagURL: nil, detailsURL: nil, startDate: Date.new(), finishDate: today, logoURL: nil, prizePool: Double.random(), countOfTeams: Int.random(), coordinates: Coordinates.new(lat: 1, lng: 1))
                            reachabilityService.connection = .wifi
                            eventsAPIService.getPageReturnValue = .just(Result(value: Page.new(content: [event], index: 1, totalPages: 1)))
                            cleanFilters()
                            eventsFiltersStorage.finishDate.accept(tomorrow)
                            
                            try? expect(sut.get(page: 1).success().toBlocking().first()?.content.count).to(equal(0))
                        }
                    }
                    
                    context("when event has not enought prize pool") {
                        it("shouldn't return this event") {
                            let prizePool: Double = 100
                            let event = Event.new(name: "", city: "", flagURL: nil, detailsURL: nil, startDate: Date(), finishDate: Date(), logoURL: nil, prizePool: prizePool, countOfTeams: Int.random(), coordinates: Coordinates.new(lat: 1, lng: 1))
                            reachabilityService.connection = .wifi
                            eventsAPIService.getPageReturnValue = .just(Result(value: Page.new(content: [event], index: 1, totalPages: 1)))
                            cleanFilters()
                            eventsFiltersStorage.minPrizePool.accept(prizePool + 1)
                            
                            try? expect(sut.get(page: 1).success().toBlocking().first()?.content.count).to(equal(0))
                        }
                    }
                    
                    context("when event has more teams") {
                        it("shouldn't return this event") {
                            let countOfTeams = 100
                            let event = Event.new(name: "", city: "", flagURL: nil, detailsURL: nil, startDate: Date(), finishDate: Date(), logoURL: nil, prizePool: 100, countOfTeams: countOfTeams, coordinates: Coordinates.new(lat: 1, lng: 1))
                            reachabilityService.connection = .wifi
                            eventsAPIService.getPageReturnValue = .just(Result(value: Page.new(content: [event], index: 1, totalPages: 1)))
                            cleanFilters()
                            eventsFiltersStorage.maxCountOfTeams.accept(countOfTeams + 1)
                            
                            try? expect(sut.get(page: 1).success().toBlocking().first()?.content.count).to(equal(0))
                        }
                    }
                }
            }
        }
    }
}
