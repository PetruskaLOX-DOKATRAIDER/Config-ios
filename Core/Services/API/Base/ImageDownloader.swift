//
//  ImageDownloader.swift
//  Core
//
//  Created by Oleg Petrychuk on 23.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Kingfisher

protocol ImageDownloader {
    func download(url: URL?, completionHandler: ((_ image: UIImage?, _ error: Error?) -> Void)?)
}

public final class ImageDownloaderImpl: ImageDownloader {
    private let kingfisherManager: KingfisherManager
    
    public init(kingfisherManager: KingfisherManager = KingfisherManager.shared) {
        self.kingfisherManager = kingfisherManager
    }
    
    public func download(
        url: URL?,
        completionHandler: ((_ image: UIImage?, _ error: Error?) -> Void)?
    ) {
        guard let url = url else { return }
        kingfisherManager.retrieveImage(with: url, options: nil, progressBlock: nil) { image, error, _, _ in
            completionHandler?(image, error as Error?)
        }
    }
}
