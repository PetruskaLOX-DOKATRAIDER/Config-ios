//
//  CoreDataStack.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 05.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class CoreDataStack {
    lazy var managedContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    lazy var privateContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = managedContext
        return context
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Bundle.coredata.name)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("NSPersistentContainer init error: \(error)")
            }
        })
        return container
    }()
    
    public init() {}
    
    func save(completion: (() -> Void)? = nil) throws {
        privateContext.perform { [weak self] in
            try? self?.privateContext.save()
            try? self?.managedContext.save()
            completion?()
        }
    }
}

public final class CoreDataStackLocator {
    private static var instance: CoreDataStack?
    
    public static func populate(_ instance: CoreDataStack) {
        self.instance = instance
    }
    
    public static var shared: CoreDataStack {
        if let instance = instance { return instance }
        fatalError("CoreDataStack instance not populated in locator")
    }
}
