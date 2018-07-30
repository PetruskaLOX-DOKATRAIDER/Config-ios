//
//  Storage+Teams.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 16.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class TeamsStorageImpl: TeamsStorage, ReactiveCompatible {
    private let coreDataStorage: CoreDataStorage<CDTeam>
    
    public init(coreDataStorage: CoreDataStorage<CDTeam> = CoreDataStorage()) {
        self.coreDataStorage = coreDataStorage
    }
    
    public func update(withNewTeams newTeams: [Team]) throws {
        try? coreDataStorage.update(withNewData: newTeams)
    }
    
    public func fetchTeams() throws -> [Team] {
        do {
            return try coreDataStorage.fetch()
        } catch {
            throw CoreDataStorageError.unknown
        }
    }
}
