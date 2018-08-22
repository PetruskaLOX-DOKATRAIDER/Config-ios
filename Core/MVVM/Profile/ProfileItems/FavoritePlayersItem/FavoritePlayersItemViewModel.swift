//
//  FavoritePlayersItemViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol FavoritePlayersItemViewModel: SectionItemViewModelType {
    var countOfPlayers: Driver<String> { get }
    var selectionTrigger: PublishSubject<Void> { get }
}

public final class FavoritePlayersItemViewModelImpl: FavoritePlayersItemViewModel {
    public let countOfPlayers: Driver<String>
    public let selectionTrigger = PublishSubject<Void>()
    
    init(playersStorage: PlayersStorage) {
        countOfPlayers = playersStorage.fetchFavoritePlayersPreview().map { players in
            players.isEmpty ? Strings.Favoriteplayers.noPlayers : Strings.Favoriteplayers.playersCount(players.count)
        }
    }
}
