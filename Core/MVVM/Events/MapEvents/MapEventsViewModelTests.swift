//
//  MapEventsViewModelTests.swift
//  Config
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class MapEventsViewModelTests: BaseTestCase {
    override func spec() {
        describe("MapEventsViewModel") {
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
            let imageLoaderService = ImageLoaderServiceMock()
            imageLoaderService.loadImageWithURLReturnValue = .just(Result(error: .unknown))
            var sut: MapEventsViewModel!
            
            beforeEach {
                sut = MapEventsViewModelImpl(events: eventsPaginator, imageLoaderService: imageLoaderService)
            }
            
            describe("when ask events") {
                it("should return valid events") {
                    try? expect(sut.events.toBlocking().first()?.count).to(equal(page.content.count))
                    try? expect(sut.events.toBlocking().first()?.first?.coordinate.latitude).to(equal(event1.coordinates.lat))
                    try? expect(sut.events.toBlocking().first()?.first?.coordinate.longitude).to(equal(event1.coordinates.lng))
                    try? expect(sut.events.toBlocking().first()?.last?.coordinate.latitude).to(equal(event2.coordinates.lat))
                    try? expect(sut.events.toBlocking().first()?.last?.coordinate.longitude).to(equal(event2.coordinates.lng))
                }
            }
            
            describe("when calling event did trigger") {
                it("should notify EventDescriptionViewModel") {
                    let observer = self.scheduler.createObserver(String.self)
                    sut.eventDescriptionViewModel.name.drive(observer).disposed(by: self.disposeBag)
                    let eventItemVM = try? sut.events.toBlocking().first()?.first
                    
                    eventItemVM??.selectionTrigger.onNext(())
                    
                    try? expect(sut.eventDescriptionViewModel.name.toBlocking().first()).to(beEmpty())
                }
            }
            
            describe("when ask is description available") {
                context("on start") {
                    it("shouldn't be avaliable") {
                        try? expect(sut.isDescriptionAvailable.toBlocking().first()).to(beFalsy())
                    }
                }
                
                context("after item did trigger") {
                    it("should be avaliable") {
                        let observer = self.scheduler.createObserver(Bool.self)
                        sut.isDescriptionAvailable.drive(observer).disposed(by: self.disposeBag)
                        let eventItemVM = try? sut.events.toBlocking().first()?.first
                        
                        eventItemVM??.selectionTrigger.onNext(())
                        
                        try? expect(sut.isDescriptionAvailable.toBlocking().first()).to(beTruthy())
                    }
                }
                
                context("after unfocus did trigger") {
                    it("shouldn't be avaliable") {
                        sut.unFocusTrigger.onNext(())
                        try? expect(sut.isDescriptionAvailable.toBlocking().first()).to(beFalsy())
                    }
                }
            }
        }
    }
}
