//
//  NewsStorageImpl.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 31.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class NewsStorageImpl: NewsStorage, ReactiveCompatible {
    private let coreDataStorage: CoreDataStorage<CDEvent>
    
    public init(coreDataStorage: CoreDataStorage<CDEvent> = CoreDataStorage()) {
        self.coreDataStorage = coreDataStorage
    }
    
    func updateNewsPreview(withNewNews newNews: [NewsPreview]) throws {
        
    }
    
    func fetchNewsPreview() throws -> [NewsPreview] {
        
    }
    
    func updateNewsDescription(withNewNews newNews: NewsDescription) throws {
        
    }
    
    func fetchNewsDescription(byID id: Int) throws -> NewsDescription? {
        
    }
}
