//
//  CCNewsTextContent+CDObjectable.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 01.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension CCNewsTextContent: CDObjectable {
    public static func new(conext: NSManagedObjectContext, plainObject: NewsTextContent) -> CCNewsTextContent {
        let cdObject = CCNewsTextContent(context: conext)
        cdObject.text = plainObject.text
        return cdObject
    }
    
    public func compare(withPlainObject plainObject: NewsTextContent) -> Bool {
        return text == plainObject.text
    }
    
    public func toPlainObject() -> NewsTextContent {
        return NewsTextContent.new(
            text: text ?? ""
        )
    }
}
