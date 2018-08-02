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
    
    public func updatePlayerPreview(withNewPlayers newPlayers: [PlayerPreview], completion: (() -> Void)? = nil) {
        playerPreviewCoreDataStorage.update(withNewData: newPlayers, completion: completion)
    }
    
    public func fetchPlayersPreview(completion: (([PlayerPreview]) -> Void)? = nil) {
        playerPreviewCoreDataStorage.fetch(completion: completion)
    }
    
    public func updatePlayerDescription(withNewPlayer newPlayer: PlayerDescription, completion: (() -> Void)? = nil) {
        playerDescriptionCoreDataStorage.update(withNewData: [newPlayer], completion: completion)
    }
    
    public func fetchPlayerDescription(withID id: Int, completion: ((PlayerDescription?) -> Void)? = nil) {
        let predicate = NSPredicate(format: "%K = %d", #keyPath(CDPlayerDescription.id), id)
        playerDescriptionCoreDataStorage.fetch(withPredicate: predicate) { players in
            completion?(players.first)
        }
    }
    
    public func fetchFavoritePlayersPreview(completion: (([PlayerPreview]) -> Void)? = nil) {
        coreDataStack.privateContext.perform { [weak self] in
            guard let strongSelf = self else { return }
            let idsRequest: NSFetchRequest = CDFavoritePlayerID.fetchRequest()
            let favoritePlayerID = try? strongSelf.coreDataStack.privateContext.fetch(idsRequest)
            let ids = (favoritePlayerID ?? []).map{ $0.id }
            
            let playersRequest: NSFetchRequest = CDPlayerPreview.fetchRequest()
            playersRequest.predicate = NSPredicate(format: "%K IN %@", #keyPath(CDPlayerPreview.id), ids)
            let players = try? strongSelf.coreDataStack.privateContext.fetch(playersRequest)
            completion?(players?.map{ $0.toPlainObject() } ?? [])
        }
    }

    public func addPlayerToFavorites(withID id: Int, completion: (() -> Void)? = nil) {
        coreDataStack.privateContext.perform { [weak self] in
            guard let strongSelf = self else { return }
            let playerID = CDFavoritePlayerID(context: strongSelf.coreDataStack.privateContext)
            playerID.id = Int32(id)
            
            try? strongSelf.coreDataStack.privateContext.save()
            try? strongSelf.coreDataStack.managedContext.save()
            completion?()
        }
    }
    
    public func removePlayerFromFavorites(withID id: Int, completion: (() -> Void)? = nil) {
        let predicate = NSPredicate(format: "%K = %d", #keyPath(CDFavoritePlayerID.id), id)
        playerDescriptionCoreDataStorage.delete(withPredicate: predicate, completion: completion)
    }
    
    public func isPlayerInFavorites(withID id: Int, completion: ((Bool) -> Void)? = nil) {
        let predicate = NSPredicate(format: "%K = %d", #keyPath(CDFavoritePlayerID.id), id)
        playerPreviewCoreDataStorage.fetch(withPredicate: predicate) { players in
            completion?(players.count > 1)
        }
    }
}
