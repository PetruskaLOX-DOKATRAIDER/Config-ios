//
//  EventDescriptionViewModelTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 24.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class EventDescriptionViewModelTests: BaseTestCase {
    override func spec() {
        describe("EventDescriptionViewModel") {
            var sut: EventDescriptionViewModelImpl!
            
            beforeEach {
                sut = EventDescriptionViewModelImpl()
            }
            
            let event = Event.new(
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
            
            describe("before event did trigger") {
                it("should have valid properties") {
                    try? expect(sut.name.toBlocking().first()).to(equal(""))
                    try? expect(sut.name.toBlocking().first()).to(equal(""))
                    try? expect(sut.flagURL.toBlocking().first().flatMap{ $0 }).to(beNil())
                    try? expect(sut.logoURL.toBlocking().first().flatMap{ $0 }).to(beNil())
                }
            }
            
            describe("when calling event did trigger") {
                it("should have valid properties") {
                    let cityObserver = self.scheduler.createObserver(String.self)
                    sut.city.drive(cityObserver).disposed(by: self.disposeBag)
                    let nameObserver = self.scheduler.createObserver(String.self)
                    sut.name.drive(nameObserver).disposed(by: self.disposeBag)
                    let logoObserver = self.scheduler.createObserver(URL?.self)
                    sut.logoURL.drive(logoObserver).disposed(by: self.disposeBag)
                    
                    sut.eventTrigger.onNext(event)
                    
                    try? expect(sut.name.toBlocking().first()).to(equal(event.name))
                    try? expect(sut.city.toBlocking().first()).to(equal(event.city))
                    try? expect(sut.flagURL.toBlocking().first().flatMap{ $0 }).to(beNil())
                    try? expect(sut.logoURL.toBlocking().first().flatMap{ $0 }).to(equal(event.logoURL))
                }
            }
            
            describe("when event share did trigger") {
                context("and details URL is not exist") {
                    it("shouldn't share event detailsURL") {
                        let observer = self.scheduler.createObserver(ShareItem.self)
                        sut.shouldShare.drive(observer).disposed(by: self.disposeBag)
                        
                        sut.shareTrigger.onNext(())
                        
                        expect(observer.events.count).to(equal(0))
                    }
                }
                
                context("and details URL is exist") {
                    it("should share event detailsURL") {
                        let observer = self.scheduler.createObserver(ShareItem.self)
                        sut.shouldShare.drive(observer).disposed(by: self.disposeBag)
                        sut.eventTrigger.onNext(event)
                        
                        sut.shareTrigger.onNext(())
                        
                        try? expect(sut.shouldShare.map{ $0.url }.toBlocking().first().flatMap{ $0 }).to(equal(event.detailsURL))
                    }
                }
            }
            
            describe("when event details did trigger") {
                context("and details URL is not exist") {
                    it("shouldn't share event detailsURL") {
                        let observer = self.scheduler.createObserver(ShareItem.self)
                        sut.shouldShare.drive(observer).disposed(by: self.disposeBag)
                        
                        sut.detailsTrigger.onNext(())
                        
                        expect(observer.events.count).to(equal(0))
                    }
                }
                
                context("and details URL is not exist") {
                    it("should open details url") {
                        let observer = self.scheduler.createObserver(URL.self)
                        sut.shouldOpenURL.drive(observer).disposed(by: self.disposeBag)
                        sut.eventTrigger.onNext(event)
                        
                        sut.detailsTrigger.onNext(())
                        
                        try? expect(sut.shouldOpenURL.toBlocking().first()).to(equal(event.detailsURL))
                    }
                }
            }
        }
    }
}
