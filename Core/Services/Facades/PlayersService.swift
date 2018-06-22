//
//  PlayersService.swift
//  Core
//
//  Created by Oleg Petrychuk on 21.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// MARK: Protocol

public protocol PlayersService {
    var playersPreview: Paginator<PlayerPreview> { get }
}

// MARK: Implementation

private final class PlayersServiceImpl: PlayersService {
    let playersPreview: Paginator<PlayerPreview>
    
    init(apiService: PlayersAPIService) {
        playersPreview = Paginator(factory: { apiService.getPlayers(forPage: $0).success().asObservable() })
    }
}

// MARK: Factory

public class PlayersServiceFactory {
    public static func `default`(
        apiService: PlayersAPIService = PlayersAPIServiceFactory.default()
    ) -> PlayersService {
        return PlayersServiceImpl(apiService: apiService)
    }
}
