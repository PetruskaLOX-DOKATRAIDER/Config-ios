//
//  Storage+Players.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 11.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class PlayersStorageImpl: PlayersStorage, ReactiveCompatible {    
    private let playerPreviewCoreDataStorage: CoreDataStorage<CDPlayerPreview>
    private let playerDescriptionCoreDataStorage: CoreDataStorage<CDPlayerDescription>
    
    public init(
        playerPreviewCoreDataStorage: CoreDataStorage<CDPlayerPreview> = CoreDataStorage(),
        playerDescriptionCoreDataStorage: CoreDataStorage<CDPlayerDescription> = CoreDataStorage()
    ) {
        self.playerPreviewCoreDataStorage = playerPreviewCoreDataStorage
        self.playerDescriptionCoreDataStorage = playerDescriptionCoreDataStorage
    }
    
    public func updatePlayerPreview(withNewPlayers newPlayers: [PlayerPreview]) throws {
        try? playerPreviewCoreDataStorage.update(withNewData: newPlayers)
    }
    
    public func fetchPlayersPreview() throws -> [PlayerPreview] {
        do {
            return try playerPreviewCoreDataStorage.fetch()
        } catch {
            throw CoreDataStorageError.unknown
        }
    }
    
    public func updatePlayerDescription(withNewPlayer newPlayer: PlayerDescription) throws {
        try? playerDescriptionCoreDataStorage.update(withNewData: [newPlayer])
    }
    
    public func fetchPlayerDescription(byPlayerID playerID: PlayerID) throws -> PlayerDescription? {
        do {
            let predicate = NSPredicate(format: "%K = %d", #keyPath(CDPlayerDescription.id), playerID)
            
            //let predicate = NSPredicate(format: "id = %d", playerID)
            return try playerDescriptionCoreDataStorage.fetch(withPredicate: predicate).first
        } catch {
            throw CoreDataStorageError.unknown
        }
    }
}
