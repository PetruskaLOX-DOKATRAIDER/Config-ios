//
//  SectionItemViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 22.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol SectionItemViewModel: SectionItemViewModelType {
    var title: Driver<String> { get }
    var icon: Driver<UIImage?> { get }
    var withDetail: Driver<Bool> { get }
    var selectionTrigger: PublishSubject<Void> { get }
}

public struct SectionItemViewModelImpl: SectionItemViewModel {
    public let title: Driver<String>
    public let icon: Driver<UIImage?>
    public let withDetail: Driver<Bool>
    public let selectionTrigger = PublishSubject<Void>()
    
    public init(
        title: String,
        icon: UIImage? = nil,
        withDetail: Bool = true
    ) {
        self.title = .just(title)
        self.icon = .just(icon)
        self.withDetail = .just(withDetail)
    }
}
