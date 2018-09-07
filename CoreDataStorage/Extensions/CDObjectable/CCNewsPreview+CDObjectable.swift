//
//  CCNewsPreview+CDObjectable.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 01.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension CCNewsPreview: CDObjectable {
    public static func new(conext: NSManagedObjectContext, plainObject: NewsPreview) -> CCNewsPreview {
        let cdObject = CCNewsPreview(context: conext)
        cdObject.title = plainObject.title
        cdObject.coverImageURL = plainObject.coverImageURL?.absoluteString
        cdObject.id = Int32(plainObject.id)
        return cdObject
    }
    
    public func compare(withPlainObject plainObject: NewsPreview) -> Bool {
        return id == plainObject.id
    }
    
    public func toPlainObject() -> NewsPreview {
        return NewsPreview.new(
            title: title ?? "",
            coverImageURL: URL(string: coverImageURL ?? ""),
            detailsURL: URL(string: coverImageURL ?? ""),
            id: Int(id)
        )
    }
}
