//
//  EventsContainerViewModelTests.swift
//  Config
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class EventsContainerViewModelTests: BaseTestCase {
    override func spec() {
        describe("EventsContainerViewModel") {
            let eventsService = EventsServiceMock()
            let eventsFiltersStorage = EventsFiltersStorageMock(startDate: BehaviorRelay(value: nil), finishDate: BehaviorRelay(value: nil), maxCountOfTeams: BehaviorRelay(value: nil), minPrizePool: BehaviorRelay(value: nil))
            let imageLoaderService = ImageLoaderServiceMock()
            var sut: EventsContainerViewModel!
            let event = Event.new(
                name: String.random(),
                city: String.random(),
                flagURL: nil,
                detailsURL: nil,
                startDate: Date.random(),
                finishDate: Date.random(),
                logoURL: URL.new(),
                prizePool: Double.new(),
                countOfTeams: Int.random(),
                coordinates: Coordinates.new(lat: Double.random(), lng: Double.random())
            )
            let content = [event]
            
            beforeEach {
                eventsService.getPageReturnValue = .just(
                    Result(value: Page.new(content: content, index: 1, totalPages: 1))
                )
                sut = EventsContainerViewModelImpl(
                    eventsService: eventsService,
                    eventsFiltersStorage: eventsFiltersStorage,
                    imageLoaderService: imageLoaderService
                )
            }
            
            describe("when calling load events did trigger") {
                context("and receives data") {
                    it("should update paginator by loaded events") {
                        expect(sut.eventsPaginator.elements.value.count).to(equal(content.count))
                        expect(sut.eventsPaginator.elements.value.first?.name).to(equal(event.name))
                        expect(sut.eventsPaginator.elements.value.first?.city).to(equal(event.city))
                    }
                }
            }
            
            describe("when filters updated") {
                it("should update events with dalay") {
                    let observer = self.scheduler.createObserver(Void.self)
                    sut.eventsPaginator.refreshTrigger.asDriver(onErrorJustReturn: ()).drive(observer).disposed(by: self.disposeBag)
                    eventsFiltersStorage.finishDate.accept(nil)
                    expect(observer.events.count).toEventually(equal(1), timeout: 1)
                    eventsFiltersStorage.startDate.accept(nil)
                    expect(observer.events.count).toEventually(equal(2), timeout: 2)
                    eventsFiltersStorage.maxCountOfTeams.accept(nil)
                    expect(observer.events.count).toEventually(equal(3), timeout: 3)
                    eventsFiltersStorage.minPrizePool.accept(nil)
                    expect(observer.events.count).toEventually(equal(4), timeout: 4)
                }
            }
            
            describe("when calling filters did trigger") {
                it("should route to filters") {
                    let observer = self.scheduler.createObserver(Void.self)
                    sut.shouldRouteFilters.drive(observer).disposed(by: self.disposeBag)
                    sut.filtersTrigger.onNext(())
                    expect(observer.events.count).to(equal(1))
                }
            }
        }
    }
}
