//
//  PickerViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 25.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public struct PickerItem<T> {
    let title: String
    let object: T
    
    public init(title: String, object: T) {
        self.title = title
        self.object = object
    }
}

public protocol PickerViewModel {
    var itmeTitles: Driver<[String]> { get }
    var title: Driver<String> { get }
    var itemAtIndexTrigger: PublishSubject<Int> { get }
    var cancelTrigger: PublishSubject<Void> { get }
    var shouldClose: Driver<Void> { get }
}

public final class PickerViewModelImpl<T>: PickerViewModel {
    public let itmeTitles: Driver<[String]>
    public let title: Driver<String>
    public let itemAtIndexTrigger = PublishSubject<Int>()
    public let cancelTrigger = PublishSubject<Void>()
    public let shouldClose: Driver<Void>
    
    public let itemPicked: Driver<PickerItem<T>>
    
    public init(
        title: String = "",
        items: [PickerItem<T>]
    ) {
        self.title = .just(title)
        itmeTitles = .just(items.map{ $0.title })
        itemPicked = itemAtIndexTrigger.map{ items[safe: $0] }.asDriver(onErrorJustReturn: nil).filterNil()
        shouldClose = .merge(cancelTrigger.asDriver(onErrorJustReturn: ()), itemPicked.toVoid())
    }
}
