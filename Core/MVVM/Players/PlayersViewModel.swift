//
//  PlayersViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// MARK: Protocol

public protocol PlayersViewModel {
    var players: Paginator<PlayerPreview> { get }
}

// MARK: Implementation

private final class PlayersViewModelImpl: PlayersViewModel {
    let players: Paginator<PlayerPreview>
    
    init(playersService: PlayersService) {
        players = playersService.playersPreview
    }
}

// MARK: Factory

public class PlayersViewModelFactory {
    public static func `default`(
        playersService: PlayersService = PlayersServiceFactory.default()
    ) -> PlayersViewModel {
        return PlayersViewModelImpl(playersService: playersService)
    }
}
