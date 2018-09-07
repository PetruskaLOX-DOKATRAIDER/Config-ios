//
//  FavoritePlayersItemViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

protocol FavoritePlayersItemViewModel: SectionItemViewModelType {
    var countOfPlayers: Driver<String> { get }
    var selectionTrigger: PublishSubject<Void> { get }
}

public final class FavoritePlayersItemViewModelImpl: FavoritePlayersItemViewModel {
    public let countOfPlayers: Driver<String>
    public let selectionTrigger = PublishSubject<Void>()
    
    init(playersStorage: PlayersStorage) {
        countOfPlayers = playersStorage.getFavoritePreview()
            .map{ $0.isEmpty ? Strings.Favoriteplayers.NoContent.title : Strings.Favoriteplayers.playersCount($0.count) }
    }
}
