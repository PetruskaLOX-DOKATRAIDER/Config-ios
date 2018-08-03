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
    
    public func updateNewsPreview(withNewNews newNews: [NewsPreview]) -> Driver<Void> {
        return Observable.create{ [weak self] observer -> Disposable in
            self?.newsPreviewCoreDataStorage.update(withNewData: newNews, completion: {
                observer.onNext(())
                //observer.onCompleted()
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: ())
    }
    
    public func fetchNewsPreview() -> Driver<[NewsPreview]> {
        return Observable.create{ [weak self] observer -> Disposable in
            self?.newsPreviewCoreDataStorage.fetch(completion: { news in
                observer.onNext(news)
                //observer.onCompleted()
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: [])
    }
    
    public func updateNewsDescription(withNewNews newNews: NewsDescription) -> Driver<Void> {
        return Observable.create{ [weak self] observer -> Disposable in
            self?.newsDescriptionCoreDataStorage.update(withNewData: [newNews], completion: {
                observer.onNext(())
                //observer.onCompleted()
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: ())
    }
    
    public func fetchNewsDescription(byID id: Int) -> Driver<NewsDescription?> {
        return Observable.create{ [weak self] observer -> Disposable in
            let predicate = NSPredicate(format: "%K = %d", #keyPath(CCNewsDescription.id), id)
            self?.newsDescriptionCoreDataStorage.fetch(withPredicate: predicate, completion: { news in
                observer.onNext(news.first)
                //observer.onCompleted()
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: nil)
    }
}
