//
//  PlayersStorage.swift
//  Core
//
//  Created by Oleg Petrychuk on 05.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol PlayersStorage: AutoMockable {
    func updatePlayerPreview(withNewPlayers newPlayers: [PlayerPreview]) throws
    func fetchPlayersPreview() throws -> [PlayerPreview]
    func updatePlayerDescription(withNewPlayer newPlayer: PlayerDescription) throws
    func fetchFavoritePlayersPreview() throws -> [PlayerPreview]
    func fetchPlayerDescription(withID id: Int) throws -> PlayerDescription?
    func addPlayerToFavorites(withID id: Int) throws
    func removePlayerFromFavorites(withID id: Int) throws
    func isPlayerInFavorites(withID id: Int) throws -> Bool
}
