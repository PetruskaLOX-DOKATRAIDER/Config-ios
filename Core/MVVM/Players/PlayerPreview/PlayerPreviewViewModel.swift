//
//  PlayerPreviewViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 22.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// MARK: Protocol

public protocol PlayerPreviewViewModel {
    var nickname: Driver<String> { get }
    var profileImageURL: Driver<URL?> { get }
}

// MARK: Implementation

private final class PlayerPreviewViewModelImpl: PlayerPreviewViewModel {
    let nickname: Driver<String>
    let profileImageURL: Driver<URL?>
    
    init(player: PlayerPreview) {
        nickname = .just(player.nickname)
        profileImageURL = .just(player.profileImageURL)
    }
}

// MARK: Factory

public class PlayerPreviewViewModelFactory {
    public static func new(
        player: PlayerPreview
    ) -> PlayerPreviewViewModel {
        return PlayerPreviewViewModelImpl(player: player)
    }
}
