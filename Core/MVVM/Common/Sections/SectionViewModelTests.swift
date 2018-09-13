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
            describe("when create SectionViewModel", {
                context("and pass default parameters") {
                    it("should have valid proporties", closure: {
                        let sut = SectionViewModel(items: [])
                        try? expect(sut.topic.filterNil().toBlocking().first()).to(beNil())
                    })
                }
                context("and pass some parameters") {
                    it("should have valid proporties", closure: {
                        let item1Title = String.random()
                        let item2Title = String.random()
                        let items: [SectionItemViewModelImpl] = [SectionItemViewModelImpl(title: item1Title), SectionItemViewModelImpl(title: item2Title)]
                        
                        let sut = SectionViewModel(
                            topic: SectionTopicViewModelImpl(),
                            subtopic: SectionSubtopicViewModelImpl(),
                            items: items
                        )
                        try? expect(sut.topic.toBlocking().first()).toNot(beNil())
                        try? expect(sut.subtopic.toBlocking().first()).toNot(beNil())
                        try? expect(sut.items.toBlocking().first()?.count).to(equal(items.count))
                    })
                }
            })
        }
    }
}
