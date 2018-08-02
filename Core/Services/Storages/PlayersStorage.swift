//
//  PlayersStorage.swift
//  Core
//
//  Created by Oleg Petrychuk on 05.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol PlayersStorage: AutoMockable {
    func updatePlayerPreview(withNewPlayers newPlayers: [PlayerPreview], completion: (() -> Void)?)
    func fetchPlayersPreview(completion: (([PlayerPreview]) -> Void)?)
    func updatePlayerDescription(withNewPlayer newPlayer: PlayerDescription, completion: (() -> Void)?)
    func fetchPlayerDescription(withID id: Int, completion: ((PlayerDescription?) -> Void)?)
    func fetchFavoritePlayersPreview(completion: (([PlayerPreview]) -> Void)?)
    func addPlayerToFavorites(withID id: Int, completion: (() -> Void)?)
    func removePlayerFromFavorites(withID id: Int, completion: (() -> Void)?)
    func isPlayerInFavorites(withID id: Int, completion: ((Bool) -> Void)?)
}
