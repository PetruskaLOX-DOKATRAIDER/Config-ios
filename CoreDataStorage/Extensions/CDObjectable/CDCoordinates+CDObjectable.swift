//
//  CDCoordinates+CDObjectable.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension CCCoordinates: CDObjectable {
    public static func new(conext: NSManagedObjectContext, plainObject: Coordinates) -> CCCoordinates {
        let cdObject = CCCoordinates(context: conext)
        cdObject.lat = plainObject.lat
        cdObject.lng = plainObject.lng
        return cdObject
    }
    
    public func compare(withPlainObject plainObject: Coordinates) -> Bool {
        return lat == plainObject.lat && lng == plainObject.lng
    }
    
    public func toPlainObject() -> Coordinates {
        return Coordinates.new(
            lat: lat,
            lng: lng
        )
    }
}
