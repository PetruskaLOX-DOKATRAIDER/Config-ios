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
    
    public func updateNewsPreview(withNewNews newNews: [NewsPreview], completion: (() -> Void)? = nil) {
        newsPreviewCoreDataStorage.update(withNewData: newNews, completion: completion)
    }
    
    public func fetchNewsPreview(completion: (([NewsPreview]) -> Void)? = nil) {
        newsPreviewCoreDataStorage.fetch(completion: completion)
    }
    
    public func updateNewsDescription(withNewNews newNews: NewsDescription, completion: (() -> Void)? = nil) {
        newsDescriptionCoreDataStorage.update(withNewData: [newNews], completion: completion)
    }
    
    public func fetchNewsDescription(byID id: Int, completion: ((NewsDescription?) -> Void)? = nil) {
        let predicate = NSPredicate(format: "%K = %d", #keyPath(CCNewsDescription.id), id)
        newsDescriptionCoreDataStorage.fetch(withPredicate: predicate) { news in
            completion?(news.first)
        }
    }
}
