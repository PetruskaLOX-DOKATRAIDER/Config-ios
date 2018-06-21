//
//  MessageViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 21.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// MARK: Protocol

public protocol MessageViewModel {
    var title: Driver<String> { get }
    var description: Driver<String> { get }
    var icon: Driver<UIImage> { get }
}

// MARK: Implementation

private final class MessageViewModelImpl: MessageViewModel {
    let title: Driver<String>
    let description: Driver<String>
    let icon: Driver<UIImage>
    
    init(
        title: String,
        description: String,
        icon: UIImage
    ) {
        self.title = .just(title)
        self.description = .just(description)
        self.icon = .just(icon)
    }
}

// MARK: Factory

public class MessageViewModelFactory {
    public static func new(
        title: String,
        description: String = "",
        icon: UIImage = Images.General.message
    ) -> MessageViewModel {
        return MessageViewModelImpl(
            title: title,
            description: description,
            icon: icon
        )
    }
    
    public static func error(
        title: String = Strings.Errors.error,
        description: String = Strings.Errors.generalMessage,
        icon: UIImage = Images.General.error
    ) -> MessageViewModel {
        return MessageViewModelImpl(
            title: title,
            description: description,
            icon: icon
        )
    }
}
