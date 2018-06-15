//
//  DIConfiguration.swift
//  Config
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Core
import Dip

extension DependencyContainer {
    func registerStorages() -> DependencyContainer {
        register(.singleton) { Configuration() }.implements(AppEnvironmentType.self, ServerEnvironmentType.self)
        register(.singleton) { UserDefaultsSessionStorage() as SessionStorageType }
        
        return self
    }
}
