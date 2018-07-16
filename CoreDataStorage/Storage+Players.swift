//
//  Storage+Players.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 11.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class PlayersStorageImpl: PlayersStorage, ReactiveCompatible {
    private let coreDataStorage: CoreDataStorage<CDPlayerPreview>
    
    public init(coreDataStorage: CoreDataStorage<CDPlayerPreview> = CoreDataStorage()) {
        self.coreDataStorage = coreDataStorage
    }
    
    public func update(withNewPlayers newPlayers: [PlayerPreview]) throws {
        try? coreDataStorage.update(withNewData: newPlayers)
    }
    
    public func fetchPlayersPreview() throws -> [PlayerPreview] {
        do {
            return try coreDataStorage.fetch()
        } catch {
            throw PlayersStorageError.unknown
        }
    }
}
