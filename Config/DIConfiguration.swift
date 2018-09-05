//
//  DIConfiguration.swift
//  Config
//
//  Created by Oleg Petrychuk on 25.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Core
import CoreDataStorage

extension DependencyContainer {
    func registerSeparateModules() -> DependencyContainer {
        register(.singleton){ AppEnvironmentImpl() }.implements(AppEnvironment.self, AppEnvironment.self)
        CoreDataStackLocator.populate(CoreDataStack())
        register(.singleton){ PlayersStorageImpl() as PlayersStorage }
        register(.singleton){ TeamsStorageImpl() as TeamsStorage }
        register(.singleton){ EventsStorageImpl() as EventsStorage }
        register(.singleton){ NewsStorageImpl() as NewsStorage }
        return self
    }
}
