//
//  StorageSetupViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol StorageSetupViewModel {
    var clearTrigger: PublishSubject<Void> { get }
}

public final class StorageSetupViewModelImpl: StorageSetupViewModel, ReactiveCompatible {
    public let clearTrigger = PublishSubject<Void>()
    
    init(imageLoaderService: ImageLoaderService) {
        clearTrigger.asDriver(onErrorJustReturn: ()).map{ imageLoaderService.clearCache() }.drive().disposed(by: rx.disposeBag)
    }
}
