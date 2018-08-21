//
//  ProfileDetailItemViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol ProfileDetailItemViewModel {
    var title: Driver<String> { get }
    var icon: Driver<UIImage> { get }
    var withDetail: Driver<Bool> { get }
    var selectionTrigger: PublishSubject<Void> { get }
}

public final class ProfileDetailItemViewModelImpl: ProfileDetailItemViewModel {
    public let title: Driver<String>
    public let icon: Driver<UIImage>
    public let withDetail: Driver<Bool>
    public let selectionTrigger = PublishSubject<Void>()
    
    init(
        title: String,
        icon: UIImage,
        withDetail: Bool = false
    ) {
        self.title = .just(title)
        self.icon = .just(icon)
        self.withDetail = .just(withDetail)
    }
}
