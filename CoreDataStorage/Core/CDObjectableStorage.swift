//
//  CDObjectableStorage.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 04.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Core

public final class CDObjectableStorage<CDObject: CDObjectable> where CDObject: NSManagedObject {
    private let coreDataStack: CoreDataStack
    
    public init(
        coreDataStack: CoreDataStack = CoreDataStackLocator.shared
    ) {
        self.coreDataStack = coreDataStack
    }
    
    func update(withNewData newData: [CDObject.PlainObject], completion: (() -> Void)? = nil) {
        coreDataStack.privateContext.perform { [weak self] in
            guard let strongSelf = self else { return }
            //let request: NSFetchRequest = CDObject.fetchRequest() // doesn't work with Generics
            let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: NSStringFromClass(CDObject.self))
            let oldData = try? strongSelf.coreDataStack.privateContext.fetch(request) as? [CDObject]
            newData.forEach { new in
                let toDelete = oldData??.filter{ $0.compare(withPlainObject: new) }.first
                toDelete >>- strongSelf.coreDataStack.privateContext.delete
            }
            _ = newData.map{ CDObject.new(conext: strongSelf.coreDataStack.privateContext, plainObject: $0) }
            try? strongSelf.coreDataStack.saveContexts()
            completion?()
        }
    }
    
    func fetch(withPredicate predicate: NSPredicate? = nil, completion: (([CDObject.PlainObject]) -> Void)? = nil) {
        coreDataStack.privateContext.perform { [weak self] in
            guard let strongSelf = self else { return }
            let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: NSStringFromClass(CDObject.self))
            request.predicate = predicate
            let data = try? strongSelf.coreDataStack.privateContext.fetch(request) as? [CDObject]
            completion?(data??.map{ $0.toPlainObject() } ?? [])
        }
    }
    
    func save(newData: [CDObject.PlainObject], completion: (() -> Void)? = nil) {
        coreDataStack.privateContext.perform { [weak self] in
            guard let strongSelf = self else { return }
            _ = newData.map{ CDObject.new(conext: strongSelf.coreDataStack.privateContext, plainObject: $0) }
            try? strongSelf.coreDataStack.saveContexts()
            completion?()
        }
    }
    
    func delete(withPredicate predicate: NSPredicate? = nil, completion: (() -> Void)? = nil) {
        coreDataStack.privateContext.perform { [weak self] in
            guard let strongSelf = self else { return }
            let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: NSStringFromClass(CDObject.self))
            request.predicate = predicate
            let optinalData = try? strongSelf.coreDataStack.privateContext.fetch(request) as? [CDObject]
            let data = (optinalData ?? []) ?? []
            data.forEach{ object in
                strongSelf.coreDataStack.privateContext.delete(object)
            }
            try? strongSelf.coreDataStack.saveContexts()
            completion?()
        }
    }
}
