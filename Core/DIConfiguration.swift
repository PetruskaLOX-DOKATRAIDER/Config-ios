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
        registerAPIServices()
        return self
    }
    
    private func registerRouter() {
        register(.unique){ DeviceRouterImpl() as DeviceRouter }
        register(.singleton) { try Router(router: AppRouter.shared, viewFactory: self, viewModelFactory: self, deviceRouter: self.resolve()) }
    }
    
    private func registerServices() {
        register(.unique){ try PlayersServiceImpl(reachabilityService: self.resolve(), playersAPIService: self.resolve(), playersStorage: self.resolve()) as PlayersService }
        register(.unique){ try TeamsServiceImpl(reachabilityService: self.resolve(), teamsAPIService: self.resolve(), teamsStorage: self.resolve()) as TeamsService }
        register(.unique){ ReachabilityServiceImpl() as ReachabilityService }
        register(.unique){ try EventsServiceImpl(reachabilityService: self.resolve(), eventsAPIService: self.resolve(), eventsStorage: self.resolve()) as EventsService }
        register(.singleton) { AppEnvironmentImpl() }.implements(AppEnvironment.self, AppEnvironment.self)
        register(.unique){ try NewsServiceImpl(reachabilityService: self.resolve(), newsAPIService: self.resolve(), newsStorage: self.resolve()) as NewsService }
        register(.unique){ PhotosAlbumServiceImpl() as PhotosAlbumService }
        register(.unique){ ImageLoaderServiceImpl() as ImageLoaderService }
        register(.unique){ CameraServiceImpl() as CameraService }
    }
    
    private func registerAPIServices() {
        register(.unique){ try API.PlayersAPIServiceImpl(tron: self.resolve(), appEnvironment: self.resolve()) as PlayersAPIService }
        register(.unique){ try API.TeamsAPIServiceImpl(tron: self.resolve(), appEnvironment: self.resolve()) as TeamsAPIService }
        register(.unique){ try API.EventsAPIServiceImpl(tron: self.resolve(), appEnvironment: self.resolve()) as EventsAPIService }
        register(.unique){ try API.NewsAPIServiceImpl(tron: self.resolve(), appEnvironment: self.resolve()) as NewsAPIService }
    }
    
    private func registerViewModels() {
        register(.unique){ try TutorialViewModelImpl(userStorage: self.resolve()) as TutorialViewModel }
        register(.unique){ try AppViewModelImpl(userStorage: self.resolve()) as AppViewModel }
        register(.unique){ try PlayersViewModelImpl(playersService: self.resolve()) as PlayersViewModel }
        register(.unique){ try TeamsViewModelImpl(teamsService: self.resolve(), playersBannerViewModel: self.resolve()) as TeamsViewModel }
        register(.unique){ try EventsContainerViewModelImpl(eventsService: self.resolve()) as EventsContainerViewModel }
        register(.unique){ try NewsViewModelImpl(newsService: self.resolve()) as NewsViewModel }
        register(.unique){ ProfileViewModelImpl() as ProfileViewModel }
        register(.unique){ try PlayersBannerViewModelImpl(playersAPIService: self.resolve()) as PlayersBannerViewModel }
        register(.unique){ try EventsFilterViewModelImpl(eventsFiltersStorage: self.resolve()) as EventsFilterViewModel }
        register(.unique){ try PlayerDescriptionViewModelImpl(playerID: $0, playersService: self.resolve()) as PlayerDescriptionViewModel }
        register(.unique){ try NewsDescriptionViewModelImpl(news: $0, newsService: self.resolve()) as NewsDescriptionViewModel }
        register(.unique){ try ImageViewerViewModelImpl(imageURL: $0, imageLoaderService: self.resolve(), photosAlbumService: self.resolve(), cameraService: self.resolve()) as ImageViewerViewModel }
    }
    
    private func registerStorages() {
        register(.singleton){ UserStorageImpl() as UserStorage }
        register(.singleton){ EventsFiltersStorageImpl() as EventsFiltersStorage }
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
