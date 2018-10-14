//
//  SkinTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 14.10.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class SkinTest: BaseTestCase {
    override func spec() {
        describe("Skin") {
            describe("when create skin") {
                context("with valid response") {
                    it("should correct parse response") {
                        let imageURL = URL.new()
                        let skin1 = try? Skin(response: "{type:history_go,data:[1011935134,188530139,Galil AR | Rocket Pop (Field-Tested),Сегодня 17:41,2338,Galil AR | Леденец (После полевых испытаний),#000000]}", coverImageApiURL: imageURL)
                        expect(skin1?.name).to(equal("Rocket Pop"))
                        expect(skin1?.gunName).to(equal("Galil AR"))
                        expect(skin1?.prise).to(equal(2))
                        
                        let skin2 = try? Skin(response: "{type:history_go,data:[310780494,0,Nova | Candy Apple (Minimal Wear),Сегодня 17:44,340,Nova | Карамельное яблоко (Немного поношенное),#000000]}", coverImageApiURL: imageURL)
                        expect(skin2?.name).to(equal("Candy Apple"))
                        expect(skin2?.gunName).to(equal("Nova"))
                        expect(skin2?.prise).to(equal(0))
                        
                        let skin3 = try? Skin(response: "{type:history_go,data:[520026993,188530139,Desert Eagle | Conspiracy (Minimal Wear),Сегодня 17:46,26002,Desert Eagle | Заговор (Немного поношенное),#000000]}", coverImageApiURL: imageURL)
                        expect(skin3?.name).to(equal("Conspiracy"))
                        expect(skin3?.gunName).to(equal("Desert Eagle"))
                        expect(skin3?.prise).to(equal(26))
                    }
                }
                
                context("with invalid response") {
                    it("should return nil") {
                        let skin1 = try? Skin(response: "", coverImageApiURL: URL.new())
                        expect(skin1).to(beNil())
                        
                        let skin2 = try? Skin(response: String.random(), coverImageApiURL: URL.new())
                        expect(skin2).to(beNil())
                    }
                }
            }
        }
    }
}
