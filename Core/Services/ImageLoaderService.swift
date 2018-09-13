//
//  ImageLoaderService.swift
//  Core
//
//  Created by Oleg Petrychuk on 02.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Kingfisher

public typealias Image = UIImage

public enum ImageLoaderServiceError: Error {
    case loadError(Error)
    case unknown
}

public protocol ImageLoaderService: AutoMockable {
    func loadImage(withURL url: URL) -> Observable<Result<Image, ImageLoaderServiceError>>
    func clearCache()
}

public final class ImageLoaderServiceImpl: ImageLoaderService {
    private let kingfisherManager: KingfisherManager
    
    public init(kingfisherManager: KingfisherManager = .shared) {
        self.kingfisherManager = kingfisherManager
    }
    
    public func loadImage(withURL url: URL) -> Observable<Result<Image, ImageLoaderServiceError>> {
        return Observable.create{ [weak self] observer in
            self?.kingfisherManager.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { image, error, _, _ in
                if let error = error {
                    observer.onNext(Result(error: .loadError(error)))
                } else if let image = image {
                    observer.onNext(Result(value: image))
                    observer.onCompleted()
                } else {
                    observer.onNext(Result(error: .unknown))
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        }
    }
    
    public func clearCache() {
        kingfisherManager.cache.clearDiskCache()
        kingfisherManager.cache.clearMemoryCache()
    }
}
