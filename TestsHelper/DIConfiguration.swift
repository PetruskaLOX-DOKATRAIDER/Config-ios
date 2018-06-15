//
//  DIConfiguration.swift
//  TestsHelper
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Core
import Dip
import TRON

extension DependencyContainer {
    public func stubTRON() -> DependencyContainer {
        self.register(.singleton){ () -> TRON in
            let tron = TRON(baseURL: "")
            tron.stubbingEnabled = true
            return tron
        }
        return self
    }
    public func stubStorages() -> DependencyContainer {
        return self
    }
    
    public func stubModels() -> DependencyContainer {
        return self
    }
}
