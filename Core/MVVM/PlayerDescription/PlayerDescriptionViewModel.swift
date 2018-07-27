//
//  PlayerDescriptionViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public typealias PlayerID = Int

public protocol PlayerDescriptionViewModel {
    var closeTrigger: PublishSubject<Void> { get }
    var shouldClose: Driver<Void> { get }
}

public final class PlayerDescriptionViewModelImpl: PlayerDescriptionViewModel {
    public let closeTrigger = PublishSubject<Void>()
    public let shouldClose: Driver<Void>

    public init(
        playerID: PlayerID,
        playersService: PlayersService
    ) {
        shouldClose = closeTrigger.asDriver(onErrorJustReturn: ())
    }
}
