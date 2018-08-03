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
    
    public func updatePlayerPreview(withNewPlayers newPlayers: [PlayerPreview]) -> Driver<Void> {
        return Observable.create{ [weak self] observer -> Disposable in
            self?.playerPreviewCoreDataStorage.update(withNewData: newPlayers, completion: {
                observer.onNext(())
                //observer.onCompleted()
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: ())
    }
    
    public func fetchPlayersPreview() -> Driver<[PlayerPreview]> {
        return Observable.create{ [weak self] observer -> Disposable in
            self?.playerPreviewCoreDataStorage.fetch(completion: { players in
                observer.onNext(players)
                //observer.onCompleted()
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: [])
    }
    
    public func updatePlayerDescription(withNewPlayer newPlayer: PlayerDescription) -> Driver<Void> {
        return Observable.create{ [weak self] observer -> Disposable in
            self?.playerDescriptionCoreDataStorage.update(withNewData: [newPlayer], completion: {
                observer.onNext(())
                //observer.onCompleted()
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: ())
    }
    
    public func fetchPlayerDescription(withID id: Int) -> Driver<PlayerDescription?> {
        return Observable.create{ [weak self] observer -> Disposable in
            let predicate = NSPredicate(format: "%K = %d", #keyPath(CDPlayerDescription.id), id)
            self?.playerDescriptionCoreDataStorage.fetch(withPredicate: predicate, completion: { players in
                observer.onNext(players.first)
                //observer.onCompleted()
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: nil)
    }
    
    public func fetchFavoritePlayersPreview() -> Driver<[PlayerPreview]> {
        return Observable.create{ [weak self] observer -> Disposable in
            guard let strongSelf = self else { return Disposables.create() }
            strongSelf.coreDataStack.privateContext.perform {
                let idsRequest: NSFetchRequest = CDFavoritePlayerID.fetchRequest()
                let favoritePlayerID = try? strongSelf.coreDataStack.privateContext.fetch(idsRequest)
                let ids = (favoritePlayerID ?? []).map{ $0.id }
                
                let playersRequest: NSFetchRequest = CDPlayerPreview.fetchRequest()
                playersRequest.predicate = NSPredicate(format: "%K IN %@", #keyPath(CDPlayerPreview.id), ids)
                let players = try? strongSelf.coreDataStack.privateContext.fetch(playersRequest)
                
                let favoritePlayers = players?.map{ $0.toPlainObject() } ?? []
                observer.onNext(favoritePlayers)
                observer.onCompleted()
            }
            return Disposables.create()
        }.asDriver(onErrorJustReturn: [])
    }
    
    public func addPlayerToFavorites(withID id: Int) -> Driver<Void> {
        return Observable.create{ [weak self] observer -> Disposable in
            guard let strongSelf = self else { return Disposables.create() }
            strongSelf.coreDataStack.privateContext.perform {
                let playerID = CDFavoritePlayerID(context: strongSelf.coreDataStack.privateContext)
                playerID.id = Int32(id)
    
                try? strongSelf.coreDataStack.privateContext.save()
                try? strongSelf.coreDataStack.managedContext.save()
                observer.onNext(())
                //observer.onCompleted()
            }
            return Disposables.create()
        }.asDriver(onErrorJustReturn: ())
    }
    
    public func removePlayerFromFavorites(withID id: Int) -> Driver<Void> {
        return Observable.create{ [weak self] observer -> Disposable in
            let predicate = NSPredicate(format: "%K = %d", #keyPath(CDFavoritePlayerID.id), id)
            self?.playerDescriptionCoreDataStorage.delete(withPredicate: predicate, completion: {
                observer.onNext(())
                //observer.onCompleted()
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: ())
    }
    
    public func isPlayerInFavorites(withID id: Int) -> Driver<Bool> {
        return Observable.create{ [weak self] observer -> Disposable in
            let predicate = NSPredicate(format: "%K = %d", #keyPath(CDFavoritePlayerID.id), id)
            self?.playerPreviewCoreDataStorage.fetch(withPredicate: predicate) { players in
                observer.onNext(players.count > 1)
                //observer.onCompleted()
            }
            return Disposables.create()
        }.asDriver(onErrorJustReturn: false)
    }
}
