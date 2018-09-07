//
//  PlayersStorage.swift
//  Core
//
//  Created by Oleg Petrychuk on 05.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol PlayersStorage {
    func updatePreview(withNew players: [PlayerPreview]) -> Driver<Void>
    func getPreview() -> Driver<[PlayerPreview]>
    func updateDescription(withNew player: PlayerDescription) -> Driver<Void>
    func getDescription(player id: Int) -> Driver<PlayerDescription?>
    func getFavoritePreview() -> Driver<[PlayerPreview]>
    func add(favourite id: Int) -> Driver<Void>
    func remove(favourite id: Int) -> Driver<Void>
    func isFavourite(player id: Int) -> Driver<Bool>
}
