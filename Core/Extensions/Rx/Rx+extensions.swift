//
//  Rx+extensions.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import RxCocoa
import Result
import RxOptional

extension ObservableType {
    public func once() -> RxSwift.Observable<Self.E> {
        return self.take(1)
    }
    
    public func toVoid() -> Observable<Void> {
        return self.map{ _ in }
    }
    
    public func map<T>(to value: T) -> Observable<T> {
        return self.map{ _ in value }
    }
}

extension SharedSequenceConvertibleType {
    public func toVoid() -> SharedSequence<SharingStrategy, Void> {
        return self.map{ _ in }
    }
    
    public func map<T>(to value: T) -> SharedSequence<SharingStrategy, T> {
        return self.map{ _ in value }
    }
    
    public func map<T>(as type: T.Type) -> SharedSequence<SharingStrategy, T?> {
        return self.map{ $0 as? T }
    }
}

extension SharedSequence where SharingStrategy == DriverSharingStrategy, E: ResultReflection {
    public func success() -> Driver<E.ModelType> {
        return map{ $0.value }.filterNil()
    }
    
    public func failure() -> Driver<E.ErrorType> {
        return map{ $0.error }.filterNil()
    }
}

public protocol ResultReflection {
    associatedtype ModelType
    associatedtype ErrorType
    
    var value: ModelType? { get }
    var error: ErrorType? { get }
}

extension Result: ResultReflection { }
