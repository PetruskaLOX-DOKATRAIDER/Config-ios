//
//  TutorialItemViewModelTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 12.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class TutorialItemViewModelTests: BaseTestCase {
    override func spec() {
        describe("TutorialItemViewModel") {
            describe("when ask proporties") {
                it("should return valid proporties") {
                    let title = String.random()
                    let description = String.random()
                    let coverImage = Images.Profile.skins
                    
                    let sut = TutorialItemViewModelImpl(title: title, description: description, coverImage: coverImage)
                    
                    try? expect(sut.title.toBlocking().first()).to(equal(title))
                    try? expect(sut.description.toBlocking().first()).to(equal(description))
                    try? expect(sut.coverImage.toBlocking().first()).to(equal(coverImage))
                }
            }
        }
    }
}
