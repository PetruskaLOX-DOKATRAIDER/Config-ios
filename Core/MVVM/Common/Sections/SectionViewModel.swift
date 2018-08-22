//
//  SectionViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 22.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

/*
    Abstaction over TableView/CollectioView dataSource
    Topic - "Header"
    Items - "Cell"
    Subtopic - "Footer"
    Now you can easily construct/update your DataSource in main VM
    You really get profit of using this only when works with piled DataSource/UI
*/

public protocol SectionViewModelType {
    var topic: Driver<SectionTopicViewModelType?> { get }
    var subtopic: Driver<SectionSubtopicViewModelType?> { get }
    var items: Driver<[SectionItemViewModelType]> { get }
}

public struct SectionViewModel: SectionViewModelType {
    public let topic: Driver<SectionTopicViewModelType?>
    public let subtopic: Driver<SectionSubtopicViewModelType?>
    public let items: Driver<[SectionItemViewModelType]>
    
    public init (
        topic: SectionTopicViewModelType? = nil,
        subtopic: SectionSubtopicViewModelType? = SectionSubtopicViewModelImpl(),
        items: [SectionItemViewModelType]
    ) {
        self.topic = .just(topic)
        self.subtopic = .just(subtopic)
        self.items = .just(items)
    }
}

public protocol SectionItemViewModelType {}
public protocol SectionTopicViewModelType {}
public protocol SectionSubtopicViewModelType {}
