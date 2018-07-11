//
//  PlayersStorageImpl.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 05.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Core
import CoreData

enum PlayersStorageError: Error {
    case unknown
}

public class PlayersStorageImpl: PlayersStorage, ReactiveCompatible {
    private let coreDataStack: CoreDataStack

    public func update(withNewPlayers newPlayers: [PlayerPreview]) throws {
        let request: NSFetchRequest = CDPlayerPreview.fetchRequest()
        guard let oldPlayers = try? coreDataStack.privateContext.fetch(request) else { throw PlayersStorageError.unknown }
        newPlayers.forEach { player in
            let toDelete = oldPlayers.filter{ $0.id == player.id }.first
            toDelete >>- coreDataStack.privateContext.delete
        }
        _ = newPlayers.map{ CDPlayerPreview.new(conext: coreDataStack.privateContext, player: $0) }
        do {
            try coreDataStack.privateContext.save()
            try coreDataStack.managedContext.save()
        } catch {
            throw PlayersStorageError.unknown
        }
    }
    
    public func fetchPlayersPreview() throws -> [PlayerPreview] {
        let request: NSFetchRequest = CDPlayerPreview.fetchRequest()
        guard let data = try? coreDataStack.privateContext.fetch(request) else { throw PlayersStorageError.unknown }
        return data.map{ PlayerPreview.new(player: $0) }
    }
    
    public init(coreDataStack: CoreDataStack = CoreDataStack()) {
        self.coreDataStack = coreDataStack
    }
    
    
}

