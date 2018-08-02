//
//  PhotosAlbumService.swift
//  Core
//
//  Created by Oleg Petrychuk on 02.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public enum PhotosAlbumServiceError: Error {
    case savingError(Error)
    case unknown
}

public protocol PhotosAlbumService {
    func save(_ image: UIImage) -> Observable<Result<Void, PhotosAlbumServiceError>>
}

public class PhotosAlbumServiceImpl: NSObject, PhotosAlbumService {
    public func save(_ image: UIImage) -> Observable<Result<Void, PhotosAlbumServiceError>> {
        print("I WILL SAVE THIS IMAGE")
        return Observable.create({ [weak self] observer -> Disposable in
            let container = ObserverContainer(withObserver: observer)
            let observerPointer: UnsafeMutableRawPointer = Unmanaged.passRetained(container).toOpaque()
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self?.image(_:didFinishSavingWithError:contextInfo:)), observerPointer)
            return Disposables.create()
        })
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        let observerContainer: ObserverContainer = Unmanaged.fromOpaque(contextInfo).takeRetainedValue()
        if let error = error {
            observerContainer.observer.onNext(Result(error: .savingError(error)))
        } else {
            observerContainer.observer.onNext(Result(value: ()))
        }
    }
    
    private class ObserverContainer {
        let observer: AnyObserver<Result<Void, PhotosAlbumServiceError>>
        init(withObserver observer: AnyObserver<Result<Void, PhotosAlbumServiceError>>) {
            self.observer = observer
        }
    }
}
