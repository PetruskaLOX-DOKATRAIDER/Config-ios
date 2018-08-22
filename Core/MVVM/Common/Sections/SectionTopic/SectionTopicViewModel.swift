//
//  SectionTopicViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 22.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol SectionTopicViewModel: SectionTopicViewModelType {
    var title: Driver<String> { get }
    var icon: Driver<UIImage?> { get }
}

public struct SectionTopicViewModelImpl: SectionTopicViewModel, ReactiveCompatible {
    public let title: Driver<String>
    public let icon: Driver<UIImage?>
    
    init(
        title: String = "",
        icon: UIImage? = nil
    ) {
        self.title = .just(title)
        self.icon = .just(icon)
    }
}
