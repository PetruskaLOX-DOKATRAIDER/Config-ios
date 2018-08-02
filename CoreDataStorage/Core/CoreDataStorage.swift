//
//  CoreDataStorage.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 11.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Core

enum CoreDataStorageError: Error {
    case notFound
    case unknown
}

public final class CoreDataStorage<CDObject: CDObjectable> where CDObject: NSManagedObject {
    let coreDataStack: CoreDataStack
    
    public init(coreDataStack: CoreDataStack = CoreDataStack()) {
        self.coreDataStack = coreDataStack
    }
    
    func update(withNewData newData: [CDObject.PlainObject]) throws {
        //let request: NSFetchRequest = CDObject.fetchRequest()
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: NSStringFromClass(CDObject.self))
        guard let oldData = (try? coreDataStack.privateContext.fetch(request) as? [CDObject]) ?? [] else { throw CoreDataStorageError.unknown }
        newData.forEach { new in
            let toDelete = oldData.filter{ $0.compare(withPlainObject: new) }.first
            toDelete >>- coreDataStack.privateContext.delete
        }
        
        try? add(newData: newData)
    }
    
    func add(newData data: [CDObject.PlainObject]) throws {
        _ = data.map{ CDObject.new(conext: coreDataStack.privateContext, plainObject: $0) }
        try? saveContexts()
    }
    
    func fetch(withPredicate predicate: NSPredicate? = nil) throws -> [CDObject.PlainObject] {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: NSStringFromClass(CDObject.self))
        request.predicate = predicate
        
//        print("step 1111")
//        coreDataStack.privateContext.perform { [weak self] in
//            let lul = try? self?.coreDataStack.privateContext.fetch(request) as? [CDObject]
//            print("step 2222: \(lul)")
//        }
//        print("step 333")
        guard let data = (try? coreDataStack.privateContext.fetch(request) as? [CDObject]) ?? [] else { throw CoreDataStorageError.unknown }
        return data.map{ $0.toPlainObject() }
    }
    
    func saveContexts() throws {
        do {
            try coreDataStack.privateContext.save()
            try coreDataStack.managedContext.save()
        } catch {
            throw CoreDataStorageError.unknown
        }
    }
}
