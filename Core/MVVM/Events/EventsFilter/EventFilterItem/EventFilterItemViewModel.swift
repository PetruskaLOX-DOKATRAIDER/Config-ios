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

public final class EventFilterItemViewModelImpl: EventFilterItemViewModel, ReactiveCompatible {
    public let title: Driver<String>
    public let icon: Driver<UIImage>
    public let withDetail: Driver<Bool>
    public let selectionTrigger = PublishSubject<Void>()
    
    public init(
        title: Driver<String>,
        icon: UIImage,
        withDetail: Bool = false
    ) {
        self.title = title
        self.icon = .just(icon)
        self.withDetail = .just(withDetail)
    }
}
