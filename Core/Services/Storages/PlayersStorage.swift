//
//  PlayersStorage.swift
//  Core
//
//  Created by Oleg Petrychuk on 05.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol PlayersStorage {
    func updatePlayerPreview(withNewPlayers newPlayers: [PlayerPreview]) -> Driver<Void>
    func fetchPlayersPreview() -> Driver<[PlayerPreview]>
    func updatePlayerDescription(withNewPlayer newPlayer: PlayerDescription) -> Driver<Void>
    func fetchPlayerDescription(withID id: Int) -> Driver<PlayerDescription?>
    func fetchFavoritePlayersPreview() -> Driver<[PlayerPreview]>
    func addPlayerToFavorites(withID id: Int) -> Driver<Void>
    func removePlayerFromFavorites(withID id: Int) -> Driver<Void>
    func isPlayerInFavorites(withID id: Int) -> Driver<Bool>
}
