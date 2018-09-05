//
//  ContextStorage.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol ContextStorageType {
    associatedtype ModelType: IDContainable
    func context(for model: ModelType) -> Context<ModelType>
}

public class ContextStorage<T: IDContainable>: ContextStorageType {
    private let storage = NSMapTable<NSString, Context<T>>(keyOptions: .strongMemory, valueOptions: .weakMemory)

    public init(){}
    
    @discardableResult
    public func context(for model: T) -> Context<T> {
        if let existingContext = storage.object(forKey: model.id as NSString) {
            existingContext.value = model
            return existingContext
        } else {
            let newContext = Context(model)
            storage.setObject(newContext, forKey: model.id as NSString)
            return newContext
        }
    }
}

public protocol IDContainable {
    var id: String { get }
    
    func updated(with value: Self) -> Self?
}

extension IDContainable {
    public func updated(with value: Self) -> Self? {
        return value
    }
}

public class Context<T: IDContainable>: ReactiveCompatible {
    fileprivate let variable: Variable<T>
    open var value: T {
        get { return variable.value }
        set { variable.value.updated(with: newValue).map{ variable.value = $0 } }
    }
    
    public init(_ value: T) {
        variable = .init(value)
    }
    
    func asDriver() -> Driver<T> {
        return variable.asDriver()
    }
}

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, E: IDContainable {
    public func drive(_ context: Context<E>) -> Disposable {
        return self.drive(onNext: {
            context.value = $0
        })
    }
}
