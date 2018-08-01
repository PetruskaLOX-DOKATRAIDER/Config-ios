//
//  NewsStorageImpl.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 31.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class NewsStorageImpl: NewsStorage, ReactiveCompatible {
    private let newsPreviewCoreDataStorage: CoreDataStorage<CCNewsPreview>
    private let newsDescriptionCoreDataStorage: CoreDataStorage<CCNewsDescription>
    
    public init(
        newsPreviewCoreDataStorage: CoreDataStorage<CCNewsPreview> = CoreDataStorage(),
        newsDescriptionCoreDataStorage: CoreDataStorage<CCNewsDescription> = CoreDataStorage()
    ) {
        self.newsPreviewCoreDataStorage = newsPreviewCoreDataStorage
        self.newsDescriptionCoreDataStorage = newsDescriptionCoreDataStorage
    }
    
    public func updateNewsPreview(withNewNews newNews: [NewsPreview]) throws {
        try? newsPreviewCoreDataStorage.update(withNewData: newNews)
    }
    
    public func fetchNewsPreview() throws -> [NewsPreview] {
        do {
            return try newsPreviewCoreDataStorage.fetch()
        } catch {
            throw CoreDataStorageError.unknown
        }
    }
    
    public func updateNewsDescription(withNewNews newNews: NewsDescription) throws {
        try? newsDescriptionCoreDataStorage.update(withNewData: [newNews])
    }
    
    public func fetchNewsDescription(byID id: Int) throws -> NewsDescription? {
        do {
            let predicate = NSPredicate(format: "%K = %d", #keyPath(CCNewsDescription.id), id)
            return try newsDescriptionCoreDataStorage.fetch(withPredicate: predicate).first
        } catch {
            throw CoreDataStorageError.unknown
        }
    }
}
