//
//  Event.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import SwiftyJSON
import TRON
import MapKit

public struct Coordinates {
    public let lat: Double
    public let lng: Double
}

extension Coordinates {
    init(locationCoordinate2D: CLLocationCoordinate2D) {
        lat = locationCoordinate2D.latitude
        lng = locationCoordinate2D.longitude
    }
}

public struct Event {
    public let name: String
    public let city: String
    public let flagURL: URL?
    public let detailsURL: URL?
    public let startDate: Date
    public let finishDate: Date
    public let logoURL: URL?
    public let prizePool: String
    public let countOfTeams: Int
    public let coordinates: Coordinates
    
    // TODO: Fix Autoinit
    public init(name: String, city: String, flagURL: URL?, detailsURL: URL?, startDate: Date, finishDate: Date, logoURL: URL?, prizePool: String, countOfTeams: Int, coordinates: Coordinates) {
        self.name = name
        self.city = city
        self.flagURL = flagURL
        self.detailsURL = detailsURL
        self.startDate = startDate
        self.finishDate = finishDate
        self.logoURL = logoURL
        self.prizePool = prizePool
        self.countOfTeams = countOfTeams
        self.coordinates = coordinates
    }
}

extension Event: JSONDecodable {
    public init(json: JSON) throws {
        name = json["name"].stringValue
        city = json["cityName"].stringValue
        flagURL = json["flagImage"].url
        detailsURL = json["ling"].url
        startDate = Date(timeIntervalSince1970: json["dateStart"].double ?? 0)
        finishDate = Date(timeIntervalSince1970: json["dateEnd"].double ?? 0)
        logoURL = json["eventLogo"].url
        prizePool = json["prizePool"].stringValue
        countOfTeams = json["countOfTeams"].intValue
        coordinates = Coordinates(lat: json["lat"].double ?? 0, lng: json["lng"].double ?? 0)
    }
}