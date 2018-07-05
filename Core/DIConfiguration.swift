//
//  DIConfiguration.swift
//  Core
//
//  Created by Oleg Petrychuk on 25.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Dip
import TRON

public extension DependencyContainer {
    @discardableResult
    public func registerAll() -> DependencyContainer {
        registerRouter()
        registerTRON()
        registerStorages()
        registerServices()
        registerViewModels()
        return self
    }
    
    private func registerRouter() {
        register(.singleton) { Router(router: AppRouter.shared, viewFactory: self, viewModelFactory: self) }
    }
    
    private func registerServices() {
        register(.singleton) { AppEnvironmentImpl() }.implements(AppEnvironment.self, AppEnvironment.self)
        register(.unique){ try API.PlayersAPIServiceImpl(tron: self.resolve(), appEnvironment: self.resolve()) as PlayersAPIService }
    }
    
    private func registerViewModels() {
        register(.unique){ try TutorialViewModelImpl(userStorage: self.resolve()) as TutorialViewModel }
        register(.unique){ try AppViewModelImpl(userStorage: self.resolve()) as AppViewModel }
        register(.unique){ try PlayersViewModelImpl(playersService: self.resolve(), playersStorage: self.resolve()) as PlayersViewModel }
        register(.unique){ TeamsViewModelImpl() as TeamsViewModel }
        register(.unique){ EventsViewModelImpl() as EventsViewModel }
        register(.unique){ NewsViewModelImpl() as NewsViewModel }
        register(.unique){ ProfileViewModelImpl() as ProfileViewModel }
    }
    
    private func registerStorages() {
        register(.singleton){ UserStorageImpl() as UserStorage }
    }

    func registerTRON() {
        register(.singleton){ () -> TRON in
            let tron = TRON(baseURL: "")
            let logger = NetworkLoggerPlugin()
            logger.logCancelledRequests = false
            logger.logSuccess = false
            tron.plugins.append(logger)
            return tron
        }
    }
}
