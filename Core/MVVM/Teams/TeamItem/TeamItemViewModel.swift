//
//  TeamItemViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 16.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol TeamItemViewModel {
    var name: Driver<String> { get }
    var logoURL: Driver<URL?> { get }
    var players: [PlayerPreviewViewModel] { get }
}

final class TeamItemViewModelImpl: TeamItemViewModel, ReactiveCompatible {
    let name: Driver<String>
    let logoURL: Driver<URL?>
    let players: [PlayerPreviewViewModel]
    
    public init(team: Team) {
        name = .just(team.name)
        logoURL = .just(team.logoURL)
        players = team.players.map{ PlayerPreviewViewModelImpl(player: $0) }
    }
}
