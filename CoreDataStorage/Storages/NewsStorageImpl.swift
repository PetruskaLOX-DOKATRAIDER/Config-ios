//
//  NewsStorageImpl.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 31.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class NewsStorageImpl: NewsStorage, ReactiveCompatible {
    private let newsPreviewObjectStorage: CDObjectableStorage<CCNewsPreview>
    private let newsDescriptionObjectStorage: CDObjectableStorage<CCNewsDescription>
    
    public init(
        newsPreviewObjectStorage: CDObjectableStorage<CCNewsPreview> = CDObjectableStorage(),
        newsDescriptionObjectStorage: CDObjectableStorage<CCNewsDescription> = CDObjectableStorage()
    ) {
        self.newsPreviewObjectStorage = newsPreviewObjectStorage
        self.newsDescriptionObjectStorage = newsDescriptionObjectStorage
    }
    
    public func updatePreview(withNew news: [NewsPreview]) -> Driver<Void> {
        return Observable.create{ [weak self] observer -> Disposable in
            self?.newsPreviewObjectStorage.update(withNewData: news, completion: {
                observer.onNext(())
                observer.onCompleted()
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: ())
    }
    
    public func getPreview() -> Driver<[NewsPreview]> {
        return Observable.create{ [weak self] observer -> Disposable in
            self?.newsPreviewObjectStorage.fetch(completion: { news in
                observer.onNext(news)
                observer.onCompleted()
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: [])
    }
    
    public func updateDescription(withNew news: NewsDescription) -> Driver<Void> {
        return Observable.create{ [weak self] observer -> Disposable in
            self?.newsDescriptionObjectStorage.update(withNewData: [news], completion: {
                observer.onNext(())
                observer.onCompleted()
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: ())
    }
    
    public func getDescription(news id: Int) -> Driver<NewsDescription?> {
        return Observable.create{ [weak self] observer -> Disposable in
            let predicate = NSPredicate(format: "%K = %d", #keyPath(CCNewsDescription.id), id)
            self?.newsDescriptionObjectStorage.fetch(withPredicate: predicate, completion: { news in
                observer.onNext(news.first)
                observer.onCompleted()
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: nil)
    }
}
