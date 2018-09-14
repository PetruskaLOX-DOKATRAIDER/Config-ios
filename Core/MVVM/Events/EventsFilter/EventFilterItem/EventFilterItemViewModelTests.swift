//
//  EventFilterItemViewModelTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 25.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class EventFilterItemViewModelTests: BaseTestCase {
    override func spec() {
        describe("EventFilterItemViewModel") {
            describe("when ask proporties") {
                it("should return valid proporties") {
                    let title = String.random()
                    let icon = Images.EventFilters.date
                    let withDetail = Bool.random()
                    
                    let sut = EventFilterItemViewModelImpl(title: .just(title), icon: icon, withDetail: withDetail)
                    
                    try? expect(sut.title.toBlocking().first()).to(equal(title))
                    try? expect(sut.icon.toBlocking().first()).to(equal(icon))
                    try? expect(sut.withDetail.toBlocking().first()).to(equal(withDetail))
                }
            }
        }
    }
}
