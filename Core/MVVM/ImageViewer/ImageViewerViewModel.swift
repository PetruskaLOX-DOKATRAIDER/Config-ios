//
//  ImageViewerViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 02.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol ImageViewerViewModel {
    var title: Driver<String> { get }
    var imageURL: Driver<URL> { get }
    var isWorking: Driver<Bool> { get }
    var messageViewModel: Driver<MessageViewModel> { get }
    var shareTrigger: PublishSubject<Void> { get }
    var saveTrigger: PublishSubject<Void> { get }
    var browserTrigger: PublishSubject<Void> { get }
    var closeTrigger: PublishSubject<Void> { get }
    var shouldClose: Driver<Void> { get }
    var shouldOpenURL: Driver<URL> { get }
}

public final class ImageViewerViewModelImpl: ImageViewerViewModel {
    public let title: Driver<String>
    public let imageURL: Driver<URL>
    public let isWorking: Driver<Bool>
    public let messageViewModel: Driver<MessageViewModel>
    public let shareTrigger = PublishSubject<Void>()
    public let saveTrigger = PublishSubject<Void>()
    public let browserTrigger = PublishSubject<Void>()
    public let closeTrigger = PublishSubject<Void>()
    public let shouldClose: Driver<Void>
    public let shouldOpenURL: Driver<URL>

    public init(
        title: String = Strings.Imageviewer.title,
        imageURL: URL,
        imageLoaderService: ImageLoaderService,
        photosAlbumService: PhotosAlbumService,
        cameraService: CameraService
    ) {
        let cameraAuthorizated = saveTrigger.filter{ cameraService.cameraAuthorizationStatus != .denied }
        let cameraDenied = saveTrigger.filter{ cameraService.cameraAuthorizationStatus == .denied }
        let loadImage = cameraAuthorizated.flatMapLatest { imageLoaderService.loadImage(withURL: imageURL) }
        let successLoadImage = loadImage.map{ $0.value }.filterNil()
        let failureLoadImage = loadImage.map{ $0.error }.filterNil()
        let saveImage = successLoadImage.flatMapLatest{ photosAlbumService.save($0) }
        let failureSaveImage = saveImage.map{ $0.error }.filterNil()
        let successSaveImage = saveImage.map{ $0.value }.filterNil()
       
        self.title = .just(title)
        self.imageURL = .just(imageURL)
        messageViewModel = Driver.merge(
            failureLoadImage.asDriver(onErrorJustReturn: ImageLoaderServiceError.unknown).map(to:
                MessageViewModelFactory.error(description: Strings.Imageviewer.failureLoadImage)
            ),
            failureSaveImage.asDriver(onErrorJustReturn: PhotosAlbumServiceError.unknown).map(to:
                MessageViewModelFactory.error(description: Strings.Imageviewer.failureSaveImage)
            ),
            successSaveImage.asDriver(onErrorJustReturn: ()).map(to:
                MessageViewModelFactory.new(title: Strings.Imageviewer.SuccessSaveImage.title, description: Strings.Imageviewer.SuccessSaveImage.description)
            ),
            cameraDenied.asDriver(onErrorJustReturn: ()).map(to:
                MessageViewModelFactory.new(title: Strings.Imageviewer.CameraDenied.title, description: Strings.Imageviewer.CameraDenied.message)
            )
        )
        isWorking = Observable.merge(
            saveTrigger.map(to: true),
            failureLoadImage.map(to: false),
            saveImage.map(to: false)
        ).startWith(false).asDriver(onErrorJustReturn: false)
        shouldClose = closeTrigger.asDriver(onErrorJustReturn: ())
        shouldOpenURL = browserTrigger.asDriver(onErrorJustReturn: ()).map(to: imageURL)
    }
}
