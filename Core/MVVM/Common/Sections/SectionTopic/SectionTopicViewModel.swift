//
//  SectionTopicViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 22.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

protocol SectionTopicViewModel: SectionTopicViewModelType {
    var title: Driver<String> { get }
    var icon: Driver<UIImage?> { get }
}

struct SectionTopicViewModelImpl: SectionTopicViewModel, ReactiveCompatible {
    let title: Driver<String>
    let icon: Driver<UIImage?>
    
    init(
        title: String = "",
        icon: UIImage? = nil
    ) {
        self.title = .just(title)
        self.icon = .just(icon)
    }
}
