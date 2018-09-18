//
//  SkinItemViewModelTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 23.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class SkinItemViewModelTests: BaseTestCase {
    override func spec() {
        describe("SkinItemViewModel") {
            describe("when ask proporties") {
                it("should have valid properties") {
                    let skin = Skin(
                        name: String.random(),
                        gunName: "gun_name",
                        prise: 1337,
                        coverImageURL: nil
                    )
    
                    let sut = SkinItemViewModelImpl(skin: skin)
                    try? expect(sut.title.toBlocking().first()).to(equal(skin.name))
                    try? expect(sut.coverImageURL.toBlocking().first().flatMap{ $0 }).to(beNil())
                }
            }
            
            describe("when ask description") {
                context("and price isn't zero") {
                    it("should have valid properties") {
                        let skin = Skin(
                            name: String.random(),
                            gunName: "gun_name",
                            prise: 1337,
                            coverImageURL: nil
                        )
                        
                        let sut = SkinItemViewModelImpl(skin: skin)
                        try? expect(sut.description.toBlocking().first()?.full).to(equal("gun_name for 1337$"))
                        try? expect(sut.description.toBlocking().first()?.highlights).to(equal(["1337$"]))
                    }
                }
                
                context("and price is zero") {
                    it("should have valid properties") {
                        let skin = Skin(
                            name: "",
                            gunName: "",
                            prise: 0,
                            coverImageURL: nil
                        )
                        
                        let sut = SkinItemViewModelImpl(skin: skin)
                        try? expect(sut.description.toBlocking().first()?.full).to(equal(" \(Strings.Skinitem.priceSubstr) \(Strings.Skinitem.free)"))
                        try? expect(sut.description.toBlocking().first()?.highlights).to(equal([Strings.Skinitem.free]))
                    }
                }
            }
        }
    }
}
