//
//  StorageSetupViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol StorageSetupViewModel: SectionItemViewModelType {
    var clearTrigger: PublishSubject<Void> { get }
    var cacheСleared: Driver<Void> { get }
}

public final class StorageSetupViewModelImpl: StorageSetupViewModel {
    public let clearTrigger = PublishSubject<Void>()
    public let cacheСleared: Driver<Void>
    
    public init(imageLoaderService: ImageLoaderService) {
        cacheСleared = clearTrigger.asDriver(onErrorJustReturn: ()).map{ imageLoaderService.clearCache() }
    }
}
