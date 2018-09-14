//
//  SectionViewModelTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 13.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class SectionViewModelTests: BaseTestCase {
    override func spec() {
        describe("SectionViewModel") {
            describe("when ask proporties") {
                it("should return valid proporties") {
                    let items = [SectionItemViewModelImpl(title: String.random()), SectionItemViewModelImpl(title: String.random())]
                    
                    let sut = SectionViewModel(
                        topic: SectionTopicViewModelImpl(),
                        subtopic: SectionSubtopicViewModelImpl(),
                        items: items
                    )
                    
                    try? expect(sut.topic.toBlocking().first()).toNot(beNil())
                    try? expect(sut.subtopic.toBlocking().first()).toNot(beNil())
                    try? expect(sut.items.toBlocking().first()?.count).to(equal(items.count))
                }
            }
        }
    }
}
