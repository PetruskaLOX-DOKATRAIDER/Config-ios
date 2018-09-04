//
//  CDTeam+CDObjectable.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 16.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension CDTeam: CDObjectable {
    public static func new(conext: NSManagedObjectContext, plainObject: Team) -> CDTeam {
        let cdObject = CDTeam(context: conext)
        cdObject.name = plainObject.name
        cdObject.logoURL = plainObject.logoURL?.absoluteString
        cdObject.id = Int32(plainObject.id)
        cdObject.playerPreview = NSSet(array: plainObject.players.map{ CDPlayerPreview.new(conext: conext, plainObject: $0) })
        return cdObject
    }
    
    public func compare(withPlainObject plainObject: Team) -> Bool {
        return id == plainObject.id
    }
    
    public func toPlainObject() -> Team {
        let cdPlayers = playerPreview?.allObjects as? [CDPlayerPreview] ?? []
        return Team.new(
            name: name ?? "",
            logoURL: URL(string: logoURL ?? ""),
            id: Int(id),
            players: cdPlayers.map{ $0.toPlainObject() }
        )
    }
}
