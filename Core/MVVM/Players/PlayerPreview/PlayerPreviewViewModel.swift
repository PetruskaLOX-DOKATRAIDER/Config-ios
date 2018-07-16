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

public final class PlayerPreviewViewModelImpl: PlayerPreviewViewModel {
    public let nickname: Driver<String>
    public let avatarURL: Driver<URL?>
    public let selectionTrigger = PublishSubject<Void>()
    private let player: PlayerPreview
    
    public init(player: PlayerPreview) {
        self.player = player
        nickname = .just(player.nickname)
        avatarURL = .just(player.avatarURL)
    }
    
    public func imageHeight(withContainerWidth containerWidth: Double) -> Double {
        return (containerWidth * player.profileImageSize.height) / player.profileImageSize.weight
    }
}
