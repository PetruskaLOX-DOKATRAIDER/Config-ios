//
//  Skin.swift
//  Core
//
//  Created by Oleg Petrychuk on 23.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public struct Skin {
    public let name: String
    public let gunName: String
    public let prise: Int
    public let coverImageURL: URL?
    
    public init(name: String, gunName: String, prise: Int, coverImageURL: URL?) {
        self.name = name
        self.gunName = gunName
        self.prise = prise
        self.coverImageURL = coverImageURL
    }
    
    public init(
        response: String,  // ¯\_(ツ)_/¯
        coverImageApiURL: URL
    ) throws {
        func gunName(response: String) -> String? {
            let tempArray1 = response.components(separatedBy: ",")
            guard let tempStr1 = tempArray1[safe: 3] else { return nil }
            let tempArray2 = tempStr1.components(separatedBy: "|")
            guard let tempStr3 = tempArray2.first else { return nil }
            return (tempStr3 as NSString).substring(to: tempStr3.count - 1)
        }

        func name(response: String) -> String? {
            let tempArray1 = response.components(separatedBy: "|")
            guard let tempStr1 = tempArray1[safe: 1] else { return nil }
            let tempArray2 = tempStr1.components(separatedBy: "(")
            guard let tempStr2 = tempArray2.first else { return nil }
            let tempStr3 = (tempStr2 as NSString).substring(to: tempStr2.count - 1)
            return (tempStr3 as NSString).substring(from: 1)
        }

        func price(response: String) -> Int? {
            let tempArray1 = response.components(separatedBy: "|")
            guard let tempStr1 = tempArray1[safe: 1] else { return nil }
            let tempArray2 = tempStr1.components(separatedBy: ",")
            guard let tempStr2 = tempArray2[safe: 2] else { return nil }
            guard let price = Double(tempStr2) else { return nil }
            return Int(price / 1000.0)
        }

        func coverImageURL(response: String) -> URL? {
            let tempArray1 = response.components(separatedBy: "[")
            guard let tempStr1 = tempArray1.first else { return nil }
            let tempArray2 = tempStr1.components(separatedBy: ",")
            guard let firstPart = tempArray2[safe: 0], let secondPart = tempArray2[safe: 1] else { return nil }
            return URL(string: "\(coverImageApiURL.absoluteString)item_\(firstPart)_\(secondPart).png")
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
