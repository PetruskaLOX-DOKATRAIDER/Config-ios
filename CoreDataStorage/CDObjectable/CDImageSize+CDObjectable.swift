//
//  CDImageSize+CDObjectable.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 12.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension CDImageSize: CDObjectable {
    public static func new(conext: NSManagedObjectContext, plainObject: ImageSize) -> CDImageSize {
        print("I WILL SAVE: \(plainObject)")
        let cdObject = CDImageSize(context: conext)
        cdObject.height = plainObject.height
        cdObject.width = plainObject.weight
        return cdObject
    }
    
    public func compare(withPlainObject plainObject: ImageSize) -> Bool {
        return height == plainObject.height && width == plainObject.weight
    }
    
    public func toPlainObject() -> ImageSize {
        return ImageSize.new(
            height: height,
            weight: width
        )
    }
}

