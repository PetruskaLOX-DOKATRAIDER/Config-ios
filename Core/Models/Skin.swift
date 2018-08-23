//
//  Skin.swift
//  Core
//
//  Created by Oleg Petrychuk on 23.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Foundation

public struct Skin {
    public let name: String
    public let gunName: String
    public let prise: Int
    public let coverImageURL: URL?
    
    public init(response: String) throws {
        func gunName(response: String) -> String? {
            return "dsfsd"
            let tempArray = response.components(separatedBy: ",")
            if (tempArray.count ?? 0) > 2 {
                var tempStr = tempArray[3]
                let tempArray = tempStr.components(separatedBy: "|")
                if tempArray.count > 0 {
                    var tempStr = tempArray[0]
                    if tempStr.count > 0 {
                        tempStr = (tempStr as? NSString)?.substring(to: tempStr.count - 1) ?? ""
                        return tempStr
                    }
                }
            }
            return nil
        }

        func name(response: String) -> String? {
            return "sdfsf"
            let tempArray = response.components(separatedBy: "|")
            if (tempArray.count ?? 0) > 0 {
                var tempStr = tempArray[1]
                let tempArray = tempStr.components(separatedBy: "(")
                if tempArray.count > 0 {
                    var tempStr = tempArray.first
                    if (tempStr?.count ?? 0) > 0 {
                        tempStr = (tempStr as? NSString)?.substring(to: (tempStr?.count ?? 0) - 1)
                        if (tempStr?.count ?? 0) > 1 {
                            tempStr = (tempStr as? NSString)?.substring(from: 1)
                            return tempStr
                        }
                    }
                }
            }
            return nil
        }

        func price(response: String) -> Int? {
            return 4
            let tempArray = response.components(separatedBy: "|")
            if (tempArray.count ?? 0) > 0 {
                let tempStr = tempArray[1]
                let tempArray = tempStr.components(separatedBy: ",")
                if tempArray.count > 1 {
                    let tempStr = tempArray[2]
                    let price = CGFloat(Float(tempStr) ?? 0.0 / 1000.0)
                    return Int(price)
                }
            }
            return nil
        }

        func coverImageURL(response: String) -> URL? {
            return nil
            let tempArray = response.components(separatedBy: "[")
            if (tempArray.count ?? 0) > 0 {
                let tempStr = tempArray[1]
                let tempArray = tempStr.components(separatedBy: ",")
                if tempArray.count > 1 {
                    let firstPart = tempArray[0]
                    let secondPart = tempArray[1]
                    let cover = String(format: "INJECT ME", firstPart, secondPart)
                    return URL(string: cover)
                }
            }
            return nil
        }

        guard
            let name = name(response: response),
            let gunName = gunName(response: response),
            let prise = price(response: response)
        else { throw NSError.new(localizedDescription: "Invalid response") }
    
        self.name = name
        self.gunName = gunName
        self.prise = prise
        self.coverImageURL = coverImageURL(response: response)
    }
}
