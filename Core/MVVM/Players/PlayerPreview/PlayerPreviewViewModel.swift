//
//  PlayerPreviewViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 22.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol PlayerPreviewViewModel {
    var nickname: Driver<String> { get }
    var avatarURL: Driver<URL?> { get }
    var selectionTrigger: PublishSubject<Void> { get }
    func imageHeight(withContainerWidth containerWidth: Double) -> Double
}

final class PlayerPreviewViewModelImpl: PlayerPreviewViewModel, ReactiveCompatible {
    let nickname: Driver<String>
    let avatarURL: Driver<URL?>
    let selectionTrigger = PublishSubject<Void>()
    private let player: PlayerPreview
    
    init(player: PlayerPreview) {
        self.player = player
        nickname = .just(player.nickname)
        avatarURL = .just(player.avatarURL)
    }
    
    func imageHeight(withContainerWidth containerWidth: Double) -> Double {
        return (containerWidth * player.profileImageSize.height) / player.profileImageSize.weight
    }
}
