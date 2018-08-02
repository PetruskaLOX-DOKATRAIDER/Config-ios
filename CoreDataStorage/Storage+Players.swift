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
    private let coreDataStack: CoreDataStack
    
    public init(
        playerPreviewCoreDataStorage: CoreDataStorage<CDPlayerPreview> = CoreDataStorage(),
        playerDescriptionCoreDataStorage: CoreDataStorage<CDPlayerDescription> = CoreDataStorage(),
        coreDataStack: CoreDataStack = CoreDataStack()
    ) {
        self.playerPreviewCoreDataStorage = playerPreviewCoreDataStorage
        self.playerDescriptionCoreDataStorage = playerDescriptionCoreDataStorage
        self.coreDataStack = coreDataStack
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
    
    public func fetchPlayerDescription(withID id: Int) throws -> PlayerDescription? {
        do {
            let predicate = NSPredicate(format: "%K = %d", #keyPath(CDPlayerDescription.id), id)
            return try playerDescriptionCoreDataStorage.fetch(withPredicate: predicate).first
        } catch {
            throw CoreDataStorageError.unknown
        }
    }
    
    public func fetchFavoritePlayersPreview() throws -> [PlayerPreview] {
        func fetchFavoritePlayerIDs() throws -> [Int32] {
            let request: NSFetchRequest = CDFavoritePlayerID.fetchRequest()
            guard let data = try? coreDataStack.privateContext.fetch(request) else { throw CoreDataStorageError.unknown }
            return data.map{ $0.id }
        }
        
        guard let favoritePlayerIDs = try? fetchFavoritePlayerIDs() else { throw CoreDataStorageError.unknown }
        let predicate = NSPredicate(format: "%K IN %@", #keyPath(CDPlayerPreview.id), favoritePlayerIDs)
        guard let players = try? playerPreviewCoreDataStorage.fetch(withPredicate: predicate) else { throw CoreDataStorageError.unknown }
        return players
    }

    public func addPlayerToFavorites(withID id: Int) throws {
        let playerID = CDFavoritePlayerID(context: coreDataStack.privateContext)
        playerID.id = Int32(id)
        coreDataStack.saveContext()
    }
    
    public func removePlayerFromFavorites(withID id: Int) throws {
        let request: NSFetchRequest = CDFavoritePlayerID.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %d", #keyPath(CDFavoritePlayerID.id), id)
        guard let data = try? coreDataStack.privateContext.fetch(request) else { throw CoreDataStorageError.unknown }
        data.forEach { objcet in
            coreDataStack.privateContext.delete(objcet)
        }
        coreDataStack.saveContext()
    }
    
    public func isPlayerInFavorites(withID id: Int) throws -> Bool {
        let request: NSFetchRequest = CDFavoritePlayerID.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %d", #keyPath(CDFavoritePlayerID.id), id)
        guard let data = try? coreDataStack.privateContext.fetch(request) else { throw CoreDataStorageError.unknown }
        return data.count > 1
    }
}
