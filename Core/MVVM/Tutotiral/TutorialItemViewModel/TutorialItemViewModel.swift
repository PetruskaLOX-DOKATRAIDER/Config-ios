//
//  TutorialItemViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 18.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// MARK: Protocol

public protocol TutorialItemViewModel {
    var title: Driver<String> { get }
    var description: Driver<String> { get }
    var coverImage: Driver<UIImage> { get }
}

// MARK: Implementation

private final class TutorialItemViewModelImpl: TutorialItemViewModel {
    let title: Driver<String>
    let description: Driver<String>
    let coverImage: Driver<UIImage>
    
    init(
        title: String,
        description: String,
        coverImage: UIImage
    ) {
        self.title = .just(title)
        self.description = .just(description)
        self.coverImage = .just(coverImage)
    }
}

// MARK: Factory

public class TutorialItemViewModelFactory {
    public static func `default`(
        title: String,
        description: String,
        coverImage: UIImage
    ) -> TutorialItemViewModel {
        return TutorialItemViewModelImpl(title: title, description: description, coverImage: coverImage)
    }
}
