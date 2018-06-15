//
//  PublishRelay+extensions.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import RxCocoa

extension PublishRelay {
    public func asDriver() -> Driver<E> {
        return self.asDriver(onErrorDriveWith: .empty())
    }
}

extension PublishRelay: ObserverType {
    public func on(_ event: Event<Element>) {
        switch event {
        case let .next(element):
            accept(element)
        default: ()
        }
    }
}
