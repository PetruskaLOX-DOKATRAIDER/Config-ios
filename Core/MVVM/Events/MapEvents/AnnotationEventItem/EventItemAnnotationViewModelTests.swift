//
//  EventItemAnnotationViewModelTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 23.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class EventItemAnnotationViewModelTests: BaseTestCase {
    override func spec() {
        describe("EventDescriptionViewModel") {
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
            let imageLoaderService = ImageLoaderServiceMock()
            imageLoaderService.loadImageWithURLReturnValue = .just(Result(error: .unknown))
            
            describe("when ask proporties") {
                it("should have valid properties") {
                    let sut = EventItemAnnotationViewModelImpl(event: event, imageLoaderService: imageLoaderService)
                    
                    expect(sut.title).toNot(beEmpty())
                    expect(sut.subtitle).to(beNil())
                    expect(sut.reusableIdentifier).toNot(beEmpty())
                    expect(sut.coordinate.latitude).to(equal(event.coordinates.lat))
                    expect(sut.coordinate.longitude).to(equal(event.coordinates.lng))
                }
            }
            
            describe("when ask logo image") {
                context("and successfully loaded logo image") {
                    it("should return loaded logo image") {
                        let image = Images.ImageViewer.save
                        imageLoaderService.loadImageWithURLReturnValue = .just(Result(value: image))
                        let sut = EventItemAnnotationViewModelImpl(event: event, imageLoaderService: imageLoaderService)
                        try? expect(sut.logoImage.filterNil().toBlocking().first()).to(equal(image))
                    }
                }
                context("and failed to loaded logo image") {
                    it("should return nil") {
                        imageLoaderService.loadImageWithURLReturnValue = .just(Result(error: .unknown))
                        let sut = EventItemAnnotationViewModelImpl(event: event, imageLoaderService: imageLoaderService)
                        try? expect(sut.logoImage.filterNil().toBlocking().first()).to(beNil())
                    }
                }
            }
        }
    }
}
