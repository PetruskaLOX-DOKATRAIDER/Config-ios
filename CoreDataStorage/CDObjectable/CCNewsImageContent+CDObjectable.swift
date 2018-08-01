//
//  CCNewsImageContent+CDObjectable.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 01.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension CCNewsImageContent: CDObjectable {
    public static func new(conext: NSManagedObjectContext, plainObject: NewsImageContent) -> CCNewsImageContent {
        let cdObject = CCNewsImageContent(context: conext)
        cdObject.coverImageURL = plainObject.coverImageURL?.absoluteString
        return cdObject
    }
    
    public func compare(withPlainObject plainObject: NewsImageContent) -> Bool {
        return coverImageURL == plainObject.coverImageURL?.absoluteString
    }
    
    public func toPlainObject() -> NewsImageContent {
        return NewsImageContent.new(
            coverImageURL: URL(string: coverImageURL ?? "")
        )
    }
}
