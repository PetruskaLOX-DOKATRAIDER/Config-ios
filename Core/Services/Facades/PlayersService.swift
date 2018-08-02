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
    case unknown
}

public protocol PlayersService: AutoMockable {
    func getPlayerPreview(forPage page: Int) -> Response<Page<PlayerPreview>, RequestError>
    func getPlayerDescription(byPlayerID playerID: PlayerID) -> Response<PlayerDescription, RequestError>
    func getFavoritePlayersPreview(forPage page: Int) throws -> Page<PlayerPreview>
    func addPlayerToFavorites(byID id: Int) throws
    func removePlayerFromFavorites(byID id: Int) throws
    func isPlayerInFavorites(playerID id: Int) throws -> Bool
}

public final class PlayersServiceImpl: PlayersService, ReactiveCompatible {
    private let playerPreviewLoaderHelper: PageDataLoaderHelper<PlayerPreview>
    private let playerDescriptionLoaderHelper: SingleDataLoaderHelper<PlayerDescription>
    private let playersStorage: PlayersStorage
    
    public init(
        reachabilityService: ReachabilityService,
        playersAPIService: PlayersAPIService,
        playersStorage: PlayersStorage
    ) {
        self.playersStorage = playersStorage
        playerPreviewLoaderHelper = PageDataLoaderHelper(
            reachabilityService: reachabilityService,
            apiSource: { playersAPIService.getPlayersPreview(forPage: $0) },
            storageSource: { try? playersStorage.fetchPlayersPreview() },
            updateStorage: { try? playersStorage.updatePlayerPreview(withNewPlayers: $0) }
        )

        playerDescriptionLoaderHelper = SingleDataLoaderHelper(
            reachabilityService: reachabilityService,
            apiSource: { playersAPIService.getPlayerDescription(byPlayerID: $0) },
            storageSource: { try? playersStorage.fetchPlayerDescription(withID: $0) },
            updateStorage: { try? playersStorage.updatePlayerDescription(withNewPlayer: $0) }
        )
    }
    
    public func getPlayerPreview(forPage page: Int) -> Response<Page<PlayerPreview>, RequestError> {
        return playerPreviewLoaderHelper.loadData(forPage: page)
    }
    
    public func getPlayerDescription(byPlayerID playerID: PlayerID) -> Response<PlayerDescription, RequestError> {
        return playerDescriptionLoaderHelper.loadModel(byID: playerID)
    }
    
    public func addPlayerToFavorites(byID id: Int) throws {
        guard let isPlayerInFavorites = try? playersStorage.isPlayerInFavorites(withID: id) else { throw PlayersServiceError.unknown }
        guard isPlayerInFavorites else { throw PlayersServiceError.playerAlreadyInFavorites }
        try? playersStorage.addPlayerToFavorites(withID: id)
    }
    
    public func removePlayerFromFavorites(byID id: Int) throws {
        guard let isPlayerInFavorites = try? playersStorage.isPlayerInFavorites(withID: id) else { throw PlayersServiceError.unknown }
        guard !isPlayerInFavorites else { throw PlayersServiceError.playerIsNotInFavorites }
        try? playersStorage.removePlayerFromFavorites(withID: id)
    }
    
    public func isPlayerInFavorites(playerID id: Int) throws -> Bool {
        guard let isPlayerInFavorites = try? playersStorage.isPlayerInFavorites(withID: id) else { throw PlayersServiceError.unknown }
        return isPlayerInFavorites
    }
    
    public func getFavoritePlayersPreview(forPage page: Int) throws -> Page<PlayerPreview> {
        guard let players = try? playersStorage.fetchFavoritePlayersPreview() else { throw PlayersServiceError.unknown }
        return Page.new(content: players, index: 1, totalPages: 1)
    }
}
