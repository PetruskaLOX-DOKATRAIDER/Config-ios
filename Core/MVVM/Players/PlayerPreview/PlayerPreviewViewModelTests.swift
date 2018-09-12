//
//  PlayerPreviewViewModelTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 12.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class PlayerPreviewViewModelTests: BaseTestCase {
    override func spec() {
        describe("PlayerPreviewViewModel") {
            describe("when create PlayerPreviewViewModel", {
                context("with some parameters") {
                    it("should have valid properties", closure: {
                        let player = PlayerPreview.new(
                            nickname: String.random(),
                            profileImageSize: ImageSize.new(height: Double.random(), weight: Double.random()),
                            avatarURL: nil,
                            id: Int.random()
                        )
                        
                        let sut = PlayerPreviewViewModelImpl(player: player)
                        try? expect(sut.nickname.toBlocking().first()).to(equal(player.nickname))
                        try? expect(sut.avatarURL.filterNil().toBlocking().first()).to(beNil())
                    })
                }
            })
            
            describe("when ask image height", {
                it("should return valid height", closure: {
                    func testsImageHeight(withImageSize imageSize: ImageSize, containerWidth: Double, expectedHeight: Double) {
                        let player = PlayerPreview.new(
                            nickname: "",
                            profileImageSize: imageSize,
                            avatarURL: nil,
                            id: 0
                        )
                        let sut = PlayerPreviewViewModelImpl(player: player)
                        expect(sut.imageHeight(withContainerWidth: containerWidth)).to(equal(expectedHeight))
                    }
                    
                    testsImageHeight(withImageSize: ImageSize.new(height: 100, weight: 100), containerWidth: 100, expectedHeight: 100)
                    testsImageHeight(withImageSize: ImageSize.new(height: 0, weight: 0), containerWidth: 0, expectedHeight: 100)
                    testsImageHeight(withImageSize: ImageSize.new(height: -4, weight: -10), containerWidth: -1, expectedHeight: -0.4)
                })
            })
        }
    }
}
