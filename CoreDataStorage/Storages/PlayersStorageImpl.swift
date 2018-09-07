//
//  PlayersStorageImpl.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 04.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class PlayersStorageImpl: PlayersStorage, ReactiveCompatible {
    private let playerPreviewObjectStorage: CDObjectableStorage<CDPlayerPreview>
    private let playerDescriptionObjectStorage: CDObjectableStorage<CDPlayerDescription>
    private let coreDataStack: CoreDataStack
    
    public init(
        playerPreviewObjectStorage: CDObjectableStorage<CDPlayerPreview> = CDObjectableStorage(),
        playerDescriptionObjectStorage: CDObjectableStorage<CDPlayerDescription> = CDObjectableStorage(),
        coreDataStack: CoreDataStack = CoreDataStackLocator.shared
    ) {
        self.playerPreviewObjectStorage = playerPreviewObjectStorage
        self.playerDescriptionObjectStorage = playerDescriptionObjectStorage
        self.coreDataStack = coreDataStack
    }
    
    public func updatePreview(withNew players: [PlayerPreview]) -> Driver<Void> {
        return Observable.create{ [weak self] observer -> Disposable in
            self?.playerPreviewObjectStorage.update(withNewData: players, completion: {
                observer.onNext(())
                observer.onCompleted()
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: ())
    }
    
    public func getPreview() -> Driver<[PlayerPreview]> {
        return Observable.create{ [weak self] observer -> Disposable in
            self?.playerPreviewObjectStorage.fetch(completion: { players in
                observer.onNext(players)
                observer.onCompleted()
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: [])
    }
    
    public func updateDescription(withNew player: PlayerDescription) -> Driver<Void> {
        return Observable.create{ [weak self] observer -> Disposable in
            self?.playerDescriptionObjectStorage.update(withNewData: [player], completion: {
                observer.onNext(())
                observer.onCompleted()
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: ())
    }
    
    public func getDescription(player id: Int) -> Driver<PlayerDescription?> {
        return Observable.create{ [weak self] observer -> Disposable in
            let predicate = NSPredicate(format: "%K = %d", #keyPath(CDPlayerDescription.id), id)
            self?.playerDescriptionObjectStorage.fetch(withPredicate: predicate, completion: { players in
                observer.onNext(players.first)
                observer.onCompleted()
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: nil)
    }
    
    public func getFavoritePreview() -> Driver<[PlayerPreview]> {
        return Observable.create{ [weak self] observer -> Disposable in
            guard let strongSelf = self else { return Disposables.create() }
            strongSelf.coreDataStack.privateContext.perform {
                let request: NSFetchRequest = CDFavoritePlayerID.fetchRequest()
                let players = try? strongSelf.coreDataStack.privateContext.fetch(request)
                let ids = (players ?? []).map{ $0.id }
                let predicate = NSPredicate(format: "%K IN %@", #keyPath(CDPlayerPreview.id), ids)
                strongSelf.playerPreviewObjectStorage.fetch(withPredicate: predicate, completion: { players in
                    observer.onNext(players)
                    observer.onCompleted()
                })
            }
            return Disposables.create()
        }.asDriver(onErrorJustReturn: [])
    }
    
    public func add(favourite id: Int) -> Driver<Void> {
        return Observable.create{ [weak self] observer -> Disposable in
            guard let strongSelf = self else { return Disposables.create() }
            strongSelf.coreDataStack.privateContext.perform {
                let player = CDFavoritePlayerID(context: strongSelf.coreDataStack.privateContext)
                player.id = Int32(id)
                try? strongSelf.coreDataStack.save()
                observer.onNext(())
                observer.onCompleted()
            }
            return Disposables.create()
        }.asDriver(onErrorJustReturn: ())
    }
    
    public func remove(favourite id: Int) -> Driver<Void> {
        return Observable.create{ [weak self] observer -> Disposable in
            self?.coreDataStack.privateContext.perform { [weak self] in
                guard let strongSelf = self else { return }
                let request: NSFetchRequest = CDFavoritePlayerID.fetchRequest()
                request.predicate = NSPredicate(format: "%K = %d", #keyPath(CDFavoritePlayerID.id), id)
                let toDelete = (try? strongSelf.coreDataStack.privateContext.fetch(request)) ?? []
                toDelete.forEach { strongSelf.coreDataStack.privateContext.delete($0) }
                try? strongSelf.coreDataStack.save()
                observer.onNext(())
                observer.onCompleted()
            }
            return Disposables.create()
        }.asDriver(onErrorJustReturn: ())
    }
    
    public func isFavourite(player id: Int) -> Driver<Bool> {
        return Observable.create{ [weak self] observer -> Disposable in
            guard let strongSelf = self else { return Disposables.create() }
            strongSelf.coreDataStack.privateContext.perform {
                let request: NSFetchRequest = CDFavoritePlayerID.fetchRequest()
                request.predicate = NSPredicate(format: "%K = %d", #keyPath(CDFavoritePlayerID.id), id)
                let optinalData = try? strongSelf.coreDataStack.privateContext.fetch(request)
                let data = (optinalData ?? [])
                observer.onNext(data.isNotEmpty)
                observer.onCompleted()
            }
            return Disposables.create()
        }.asDriver(onErrorJustReturn: false)
    }
}
