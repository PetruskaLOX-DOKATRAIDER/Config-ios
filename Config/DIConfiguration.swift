//
//  DIConfiguration.swift
//  Config
//
//  Created by Oleg Petrychuk on 25.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Core
import Dip

extension DependencyContainer {
    func registerStorages() -> DependencyContainer {
        register(.singleton) { AppEnvironmentImpl() }.implements(AppEnvironment.self, AppEnvironment.self)
        return self
    }
}
