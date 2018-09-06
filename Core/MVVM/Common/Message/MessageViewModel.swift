//
//  MessageViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 21.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol MessageViewModel {
    var title: Driver<String> { get }
    var description: Driver<String> { get }
    var icon: Driver<UIImage> { get }
}

public final class MessageViewModelImpl: MessageViewModel {
    public let title: Driver<String>
    public let description: Driver<String>
    public let icon: Driver<UIImage>
    
    public init(
        title: String,
        description: String,
        icon: UIImage = Images.General.message
    ) {
        self.title = .just(title)
        self.description = .just(description)
        self.icon = .just(icon)
    }
}

extension MessageViewModelImpl {
    static func error(
        title: String = Strings.Errors.error,
        description: String = Strings.Errors.generalMessage,
        icon: UIImage = Images.General.error
    ) -> MessageViewModelImpl {
        return MessageViewModelImpl(
            title: title,
            description: description,
            icon: icon
        )
    }
}
