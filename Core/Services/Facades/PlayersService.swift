//
//  PlayersService.swift
//  Core
//
//  Created by Oleg Petrychuk on 11.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol PlayersService: AutoMockable {
    func getPlayers(forPage page: Int) -> Response<Page<PlayerPreview>, RequestError>
}

public final class PlayersServiceImpl: PlayersService, ReactiveCompatible {
    private let dataLoaderHelper: DataLoaderHelper<PlayerPreview>
    
    public init(
        reachabilityService: ReachabilityService,
        playersAPIService: PlayersAPIService,
        playersStorage: PlayersStorage
    ) {
        dataLoaderHelper = DataLoaderHelper(
            reachabilityService: reachabilityService,
            apiSource: { playersAPIService.getPlayers(forPage: $0) },
            storageSource: { try? playersStorage.fetchPlayersPreview() },
            updateStorage: { try? playersStorage.update(withNewPlayers: $0) }
        )
    }
    
    public func getPlayers(forPage page: Int) -> Response<Page<PlayerPreview>, RequestError> {
        return dataLoaderHelper.loadData(forPage: page)
    }
}
