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
}

public protocol PickerViewModel {
    var itemTitles: Driver<[String]> { get }
    var title: Driver<String> { get }
    var itemAtIndexTrigger: PublishSubject<Int> { get }
    var cancelTrigger: PublishSubject<Void> { get }
    var shouldClose: Driver<Void> { get }
}

final class PickerViewModelImpl<T>: PickerViewModel {
    let itemTitles: Driver<[String]>
    let title: Driver<String>
    let itemAtIndexTrigger = PublishSubject<Int>()
    let cancelTrigger = PublishSubject<Void>()
    let shouldClose: Driver<Void>
    
    let itemPicked: Driver<PickerItem<T>>
    
    init(
        title: String = "",
        items: [PickerItem<T>]
    ) {
        self.title = .just(title)
        itemTitles = .just(items.map{ $0.title })
        itemPicked = itemAtIndexTrigger.map{ items[safe: $0] }.asDriver(onErrorJustReturn: nil).filterNil()
        shouldClose = .merge(
            cancelTrigger.asDriver(onErrorJustReturn: ()),
            itemPicked.toVoid()
        )
    }
}
