//
//  CDEvent+CDObjectable.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension CDEvent: CDObjectable {
    public static func new(conext: NSManagedObjectContext, plainObject: Event) -> CDEvent {
        let cdObject = CDEvent(context: conext)
        cdObject.name = plainObject.name
        cdObject.city = plainObject.city
        cdObject.flagURL = plainObject.flagURL?.absoluteString
        cdObject.detailsURL = plainObject.detailsURL?.absoluteString
        cdObject.startDate = plainObject.startDate
        cdObject.finishDate = plainObject.finishDate
        cdObject.logoURL = plainObject.logoURL?.absoluteString
        cdObject.prizePool = plainObject.prizePool
        cdObject.countOfTeams = Int64(plainObject.countOfTeams)
        cdObject.coordinates = CCCoordinates.new(conext: conext, plainObject: plainObject.coordinates)
        return cdObject
    }
    
    public func compare(withPlainObject plainObject: Event) -> Bool {
        return self.detailsURL ?? "1" == plainObject.detailsURL?.absoluteString ?? "2"
    }
    
    public func toPlainObject() -> Event {
        return Event(
            name: name ?? "",
            city: city ?? "",
            flagURL: URL(string: flagURL ?? ""),
            detailsURL: URL(string: detailsURL ?? ""),
            startDate: startDate ?? Date(),
            finishDate: finishDate ?? Date(),
            logoURL: URL(string: logoURL ?? ""),
            prizePool: prizePool ?? "",
            countOfTeams: Int(countOfTeams),
            coordinates: coordinates?.toPlainObject() ?? Coordinates.new(lat: 0, lng: 0)
        )
    }
}
