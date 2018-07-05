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
    func imageHeight(withContainerWidth containerWidth: Double) -> Double
}

public final class PlayerPreviewViewModelImpl: PlayerPreviewViewModel {
    public let nickname: Driver<String>
    public let avatarURL: Driver<URL?>
    private let profileImageSize: ImageSize
    
    public init(player: PlayerPreview) {
        nickname = .just(player.nickname)
        avatarURL = .just(player.avatarURL)
        profileImageSize = player.profileImageSize
    }
    
    public func imageHeight(withContainerWidth containerWidth: Double) -> Double {
        return (containerWidth * profileImageSize.height) / profileImageSize.weight
    }
}
