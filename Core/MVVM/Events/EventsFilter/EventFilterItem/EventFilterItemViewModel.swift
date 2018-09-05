//
//  EventFilterItemViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 25.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol EventFilterItemViewModel {
    var title: Driver<String> { get }
    var icon: Driver<UIImage> { get }
    var withDetail: Driver<Bool> { get }
    var selectionTrigger: PublishSubject<Void> { get }
}

final class EventFilterItemViewModelImpl: EventFilterItemViewModel, ReactiveCompatible {
    let title: Driver<String>
    let icon: Driver<UIImage>
    let withDetail: Driver<Bool>
    let selectionTrigger = PublishSubject<Void>()
    
    init(
        title: Driver<String>,
        icon: UIImage,
        withDetail: Bool = false
    ) {
        self.title = title
        self.icon = .just(icon)
        self.withDetail = .just(withDetail)
    }
}
