//
//  CDPlayerPreview.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 12.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension CDPlayerPreview: CDObjectable {
    public static func new(conext: NSManagedObjectContext, plainObject: PlayerPreview) -> CDPlayerPreview {
        let cdObject = CDPlayerPreview(context: conext)
        cdObject.nickname = plainObject.nickname
        cdObject.profileImageSize = CDImageSize.new(conext: conext, plainObject: plainObject.profileImageSize)
        cdObject.avatarURL = plainObject.avatarURL?.absoluteString
        cdObject.id = Int32(plainObject.id)
        print("TO SAVE: \(cdObject.profileImageSize?.height):\(cdObject.profileImageSize?.width)")
        return cdObject
    }
    
    public func compare(withPlainObject plainObject: PlayerPreview) -> Bool {
        return id == plainObject.id
    }
    
    public func toPlainObject() -> PlayerPreview {
        var profileImageSize = ImageSize.new(height: 0, weight: 0)
        if let cdProfileImageSize = self.profileImageSize {
            profileImageSize = ImageSize.new(height: cdProfileImageSize.height, weight: cdProfileImageSize.width)
        }
        
        print("GOT: \(self.profileImageSize?.height):\(self.profileImageSize?.width)")
        
        return PlayerPreview.new(
            nickname: nickname ?? "",
            profileImageSize: profileImageSize,
            avatarURL: URL(string: avatarURL ?? ""),
            id: Int(id)
        )
    }
}
