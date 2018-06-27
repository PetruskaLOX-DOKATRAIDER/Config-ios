//
//  DIConfiguration.swift
//  Core
//
//  Created by Oleg Petrychuk on 25.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Dip

public extension DependencyContainer {
    @discardableResult
    public func registerAll() -> DependencyContainer {
        registerRouter()
        registerStorages()
        registerServices()
        registerViewModels()
        return self
    }
    
    private func registerRouter() {
        register(.singleton) { Router(router: AppRouter.shared, viewFactory: self, viewModelFactory: self) }
    }
    
    private func registerServices() {
       
    }
    
    private func registerViewModels() {
        register(.unique){ try TutorialViewModelImpl(userStorage: self.resolve()) as TutorialViewModel }
        register(.unique){ try AppViewModelImpl(userStorage: self.resolve()) as AppViewModel }
        register(.unique){ PlayersViewModelImpl() as PlayersViewModel }
        register(.unique){ TeamsViewModelImpl() as TeamsViewModel }
        register(.unique){ EventsViewModelImpl() as EventsViewModel }
        register(.unique){ NewsViewModelImpl() as NewsViewModel }
        register(.unique){ ProfileViewModelImpl() as ProfileViewModel }
    }
    
    private func registerStorages() {
        register(.singleton){ UserStorageImpl() as UserStorage }
    }
}
