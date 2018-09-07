//
//  Event.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

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
    public let prizePool: Double
    public let countOfTeams: Int
    public let coordinates: Coordinates
}

extension Event: JSONDecodable {
    public init(json: JSON) throws {
        name = json["name"].stringValue
        city = json["cityName"].stringValue
        flagURL = json["flagImage"].url
        detailsURL = json["link"].url
        startDate = Date(timeIntervalSince1970: Double(json["dateStart"].stringValue) ?? 0)
        finishDate = Date(timeIntervalSince1970: Double(json["dateEnd"].stringValue) ?? 0)
        logoURL = json["eventLogo"].url
        prizePool = json["prizePool"].doubleValue
        countOfTeams = json["countOfTeams"].intValue
        coordinates = Coordinates(lat: Double(json["lat"].stringValue) ?? 0, lng: Double(json["lng"].stringValue) ?? 0)
    }
}
