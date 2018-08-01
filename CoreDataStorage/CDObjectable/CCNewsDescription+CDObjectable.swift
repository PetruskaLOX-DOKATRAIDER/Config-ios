//
//  CCNewsDescription+CDObjectable.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 01.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension CCNewsDescription: CDObjectable {
    public static func new(conext: NSManagedObjectContext, plainObject: NewsDescription) -> CCNewsDescription {
        let cdObject = CCNewsDescription(context: conext)
        cdObject.title = plainObject.title
        cdObject.date = plainObject.date
        cdObject.author = plainObject.author
        cdObject.moreInfoURL = plainObject.moreInfoURL?.absoluteString
        cdObject.id = Int32(plainObject.id)
        var cdContent = [CCNewsContent]()
        plainObject.content.forEach { content in
            if let imageContent = content as? NewsImageContent {
                cdContent.append(CCNewsImageContent.new(conext: conext, plainObject: imageContent))
            } else if let textContent = content as? NewsTextContent {
                cdContent.append(CCNewsTextContent.new(conext: conext, plainObject: textContent))
            }
        }
        cdObject.content = NSSet(array: cdContent)
        return cdObject
    }
    
    public func compare(withPlainObject plainObject: NewsDescription) -> Bool {
        return id == plainObject.id
    }
    
    public func toPlainObject() -> NewsDescription {
        let cdContent = (self.content ?? NSSet()) as? Set<CCNewsContent> ?? Set<CCNewsContent>()
        var plainContent = [NewsContent]()
        cdContent.forEach { content in
            if let imageContent = content as? CCNewsImageContent {
                plainContent.append(imageContent.toPlainObject())
            } else if let textContent = content as? CCNewsTextContent {
                plainContent.append(textContent.toPlainObject())
            }
        }
        
        return NewsDescription.new(
            title: title ?? "",
            date: date ?? Date(),
            author: author ?? "",
            moreInfoURL: URL(string: moreInfoURL ?? ""),
            id: Int(id),
            content: plainContent
        )
    }
}
