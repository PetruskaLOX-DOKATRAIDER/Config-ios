//
//  PlayersService.swift
//  Core
//
//  Created by Oleg Petrychuk on 11.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol PlayersService: AutoMockable {
    func getPlayerPreview(forPage page: Int) -> Response<Page<PlayerPreview>, RequestError>
    func getPlayerDescription(byPlayerID playerID: PlayerID) -> Response<PlayerDescription, RequestError>
}

public final class PlayersServiceImpl: PlayersService, ReactiveCompatible {
    private let playerPreviewLoaderHelper: PageDataLoaderHelper<PlayerPreview>
    private let playerDescriptionLoaderHelper: SingleDataLoaderHelper<PlayerDescription>
    
    public init(
        reachabilityService: ReachabilityService,
        playersAPIService: PlayersAPIService,
        playersStorage: PlayersStorage
    ) {
        playerPreviewLoaderHelper = PageDataLoaderHelper(
            reachabilityService: reachabilityService,
            apiSource: { playersAPIService.getPlayersPreview(forPage: $0) },
            storageSource: { try? playersStorage.fetchPlayersPreview() },
            updateStorage: { try? playersStorage.updatePlayerPreview(withNewPlayers: $0) }
        )

        
        playerDescriptionLoaderHelper = SingleDataLoaderHelper(
            reachabilityService: reachabilityService,
            apiSource: { playersAPIService.getPlayerDescription(byPlayerID: $0) },
            storageSource: { try? playersStorage.fetchPlayerDescription(byPlayerID: $0) },
            updateStorage: { try? playersStorage.updatePlayerDescription(withNewPlayer: $0) }
        )
    }
    
    public func getPlayerPreview(forPage page: Int) -> Response<Page<PlayerPreview>, RequestError> {
        return playerPreviewLoaderHelper.loadData(forPage: page)
    }
    
    public func getPlayerDescription(byPlayerID playerID: PlayerID) -> Response<PlayerDescription, RequestError> {
        return playerDescriptionLoaderHelper.loadModel(byID: playerID)
    }
}
