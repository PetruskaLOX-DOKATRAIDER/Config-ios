//
//  DIConfiguration.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TRON
import Dip
import Alamofire

public extension DependencyContainer {
    @discardableResult
    public func registerAll() -> DependencyContainer {
        registerRouter()
        registerStorages()
        registerTRON()
        registerAPIServices()
        registerServices()
        registerViewModels()
        registerFactories()
        return self
    }
    
    public func registerRouter() {
        register(.singleton) { Router(router: AppRouter.shared, viewFactory: self, viewModelFactory: self) }
    }
    
    public func registerTRON() {
        register(.singleton){ UnauthorizedPlugin() }.implements(AuthPluginType.self)
        register(.singleton) { AuthorizationRequestAdapter(tokenStorage: try self.resolve()) as RequestAdapter }
        register(.singleton){ () -> TRON in
            let environment = try self.resolve() as ServerEnvironmentType
            let manager = TRON.defaultAlamofireManager()
            manager.adapter = try self.resolve()
            let tron = TRON(baseURL: environment.apiURL, manager: manager)
            let logger = NetworkLoggerPlugin()
            logger.logCancelledRequests = false
            logger.logSuccess = false
            tron.plugins.append(logger)
            tron.plugins.append(try self.resolve() as UnauthorizedPlugin)
            return tron
        }
    }
    
    public func registerAPIServices() {
        
    }
    
    public func registerServices() {
        register(.singleton) { try PushNotificationsHandler(service: self.resolve(), sessionStorage: self.resolve()) as PushNotificationsHandlerType }
    }
    
    public func registerViewModels() {
        register(.singleton) { try AppViewModel(sessionStorage: self.resolve(), authPlugin: self.resolve(), environment: self.resolve()) as AppViewModelType }
    }
    
    public func registerFactories() {
    }
    
    public func registerStorages() {
        register(.singleton) { UserDefaultsSessionStorage(sessionKey: "session") as SessionStorageType }
    }
}
