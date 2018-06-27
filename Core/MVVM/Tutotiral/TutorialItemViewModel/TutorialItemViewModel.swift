//
//  TutorialItemViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 18.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol TutorialItemViewModel {
    var title: Driver<String> { get }
    var description: Driver<String> { get }
    var coverImage: Driver<UIImage> { get }
}


public final class TutorialItemViewModelImpl: TutorialItemViewModel {
    public let title: Driver<String>
    public let description: Driver<String>
    public let coverImage: Driver<UIImage>
    
    public init(
        title: String,
        description: String,
        coverImage: UIImage
    ) {
        self.title = .just(title)
        self.description = .just(description)
        self.coverImage = .just(coverImage)
    }
}
