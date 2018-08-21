//
//  PlayersService.swift
//  Core
//
//  Created by Oleg Petrychuk on 11.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public enum PlayersServiceError: Error {
    case playerIsNotInFavorites
    case playerAlreadyInFavorites
    case serverError(Error)
    case noData
    case unknown
}

public protocol PlayersService: AutoMockable {
    func getPlayerPreview(forPage page: Int) -> DriverResult<Page<PlayerPreview>, PlayersServiceError>
    func getPlayerDescription(byPlayerID playerID: PlayerID) -> DriverResult<PlayerDescription, PlayersServiceError>
    func getFavoritePlayersPreview(forPage page: Int) -> DriverResult<[PlayerPreview], PlayersServiceError>
    func addPlayerToFavorites(byID id: Int) -> DriverResult<Void, PlayersServiceError>
    func removePlayerFromFavorites(byID id: Int) -> DriverResult<Void, PlayersServiceError>
    func isPlayerInFavorites(playerID id: Int) -> DriverResult<Bool, PlayersServiceError>
}

public final class PlayersServiceImpl: PlayersService, ReactiveCompatible {
    private let reachabilityService: ReachabilityService
    private let playersAPIService: PlayersAPIService
    private let playersStorage: PlayersStorage
    
    public init(
        reachabilityService: ReachabilityService,
        playersAPIService: PlayersAPIService,
        playersStorage: PlayersStorage
    ) {
        self.reachabilityService = reachabilityService
        self.playersAPIService = playersAPIService
        self.playersStorage = playersStorage
    }
    
    public func getPlayerPreview(forPage page: Int) -> DriverResult<Page<PlayerPreview>, PlayersServiceError> {
        guard reachabilityService.connection != .none else { return getStoredPlayerPreview() }
        let request = getRemotePlayerPreview(forPage: page)
        return Driver.merge(request, updatePlayerPreview(request.success()))
    }
    
    public func getPlayerDescription(byPlayerID playerID: PlayerID) -> DriverResult<PlayerDescription, PlayersServiceError> {
        guard reachabilityService.connection != .none else { return getStoredPlayerDescription(byID: playerID) }
        let request = getRemotePlayerDescription(byID: playerID)
        return .merge(request, updatePlayerDescription(request.success()))
    }

    public func getFavoritePlayersPreview(forPage page: Int) -> DriverResult<[PlayerPreview], PlayersServiceError> {
        let players = playersStorage.fetchFavoritePlayersPreview()
        return .merge(
            players.filter{ $0.isEmpty }.map(to: Result(error: .noData)),
            players.filterEmpty().map{ Result(value: $0) }
        )
    }
    
    public func addPlayerToFavorites(byID id: Int) -> DriverResult<Void, PlayersServiceError> {
        let alreadyInFavorites = playersStorage.isPlayerInFavorites(withID: id).filter{ $0 }
        let success = playersStorage.addPlayerToFavorites(withID: id)
        return .merge(
            alreadyInFavorites.map(to: Result(error: .playerAlreadyInFavorites) ),
            success.map{ Result(value: ()) }
        )
    }
    
    public func removePlayerFromFavorites(byID id: Int) -> DriverResult<Void, PlayersServiceError> {
        let isNotInFavorites = playersStorage.isPlayerInFavorites(withID: id).filter{ !$0 }
        let success = playersStorage.removePlayerFromFavorites(withID: id)
        return .merge(
            isNotInFavorites.map(to: Result(error: .playerIsNotInFavorites) ),
            success.map{ Result(value: ()) }
        )
    }
    
    public func isPlayerInFavorites(playerID id: Int) -> DriverResult<Bool, PlayersServiceError> {
        return playersStorage.isPlayerInFavorites(withID: id).map{ Result(value: $0) }
    }
    
    private func getRemotePlayerPreview(forPage page: Int) -> DriverResult<Page<PlayerPreview>, PlayersServiceError> {
        let request = playersAPIService.getPlayersPreview(forPage: page)
        let noData = request.success().filter{ $0.content.isEmpty }.toVoid()
        let successData = request.success().filter{ $0.content.isNotEmpty }
        return .merge(
            successData.map{ Result(value: $0) },
            noData.map(to: Result(error: .noData)),
            request.failure().map{ Result(error: .serverError($0.localizedDescription)) }
        )
    }
    
    private func updatePlayerPreview(_ remotePlayerPreview: Driver<Page<PlayerPreview>>) -> DriverResult<Page<PlayerPreview>, PlayersServiceError> {
        return remotePlayerPreview.flatMapLatest{ [weak self] page -> Driver<Page<PlayerPreview>> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.playersStorage.updatePlayerPreview(withNewPlayers: page.content).map(to: page)
        }.map{ Result(value: $0) }
    }
    
    private func getStoredPlayerPreview() -> DriverResult<Page<PlayerPreview>, PlayersServiceError> {
        let data = playersStorage.fetchPlayersPreview()
        return .merge(
            data.map{ Result(value: Page.new(content: $0, index: 1, totalPages: 1)) },
            data.filterEmpty().map(to: Result(error: .noData))
        )
    }
    
    private func getRemotePlayerDescription(byID id: Int) -> DriverResult<PlayerDescription, PlayersServiceError> {
        let request = playersAPIService.getPlayerDescription(byPlayerID: id)
        return .merge(
            request.success().map{ Result(value: $0) },
            request.failure().map{ Result(error: .serverError($0.localizedDescription)) }
        )
    }
    
    private func updatePlayerDescription(_ remotePlayerDescription: Driver<PlayerDescription>) -> DriverResult<PlayerDescription, PlayersServiceError> {
        return remotePlayerDescription.flatMapLatest { [weak self] player -> Driver<PlayerDescription> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.playersStorage.updatePlayerDescription(withNewPlayer: player).map(to: player)
        }.map{ Result(value: $0) }
    }
    
    private func getStoredPlayerDescription(byID id: Int) -> DriverResult<PlayerDescription, PlayersServiceError> {
        let data = playersStorage.fetchPlayerDescription(withID: id)
        return .merge(
            data.filter{ $0 == nil }.map(to: Result(error: .noData)),
            data.filterNil().map{ Result(value: $0) }
        )
    }
}
