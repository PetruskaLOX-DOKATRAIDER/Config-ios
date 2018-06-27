//
//  PlayerPreviewViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 22.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol PlayerPreviewViewModel {
    var nickname: Driver<String> { get }
    var profileImageURL: Driver<URL?> { get }
}

public final class PlayerPreviewViewModelImpl: PlayerPreviewViewModel {
    public let nickname: Driver<String>
    public let profileImageURL: Driver<URL?>
    
    public init(player: PlayerPreview) {
        nickname = .just(player.nickname)
        profileImageURL = .just(player.profileImageURL)
    }
}
