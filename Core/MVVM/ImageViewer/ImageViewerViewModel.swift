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
    var messageViewModel: Driver<MessageViewModel> { get }
    var alertViewModel: Driver<AlertViewModel> { get }
    var shareTrigger: PublishSubject<Void> { get }
    var saveTrigger: PublishSubject<Void> { get }
    var browserTrigger: PublishSubject<Void> { get }
    var closeTrigger: PublishSubject<Void> { get }
    var shouldClose: Driver<Void> { get }
    var shouldOpenURL: Driver<URL> { get }
    var shouldRouteAppSettings: Driver<Void> { get }
    var shouldShare: Driver<ShareItem> { get }
}

public final class ImageViewerViewModelImpl: ImageViewerViewModel {
    public let title: Driver<String>
    public let imageURL: Driver<URL>
    public let messageViewModel: Driver<MessageViewModel>
    public let alertViewModel: Driver<AlertViewModel>
    public let shareTrigger = PublishSubject<Void>()
    public let saveTrigger = PublishSubject<Void>()
    public let browserTrigger = PublishSubject<Void>()
    public let closeTrigger = PublishSubject<Void>()
    public let shouldClose: Driver<Void>
    public let shouldOpenURL: Driver<URL>
    public let shouldRouteAppSettings: Driver<Void>
    public let shouldShare: Driver<ShareItem>

    public init(
        title: String = Strings.Imageviewer.title,
        imageURL: URL,
        imageLoaderService: ImageLoaderService,
        photosAlbumService: PhotosAlbumService,
        cameraService: CameraService
    ) {
        self.title = .just(title)
        self.imageURL = .just(imageURL)
        
        let cameraAuthorizated = saveTrigger.filter{ cameraService.cameraAuthorizationStatus != .denied }
        let cameraDenied = saveTrigger.filter{ cameraService.cameraAuthorizationStatus == .denied }
        let loadImage = cameraAuthorizated.flatMapLatest { imageLoaderService.loadImage(withURL: imageURL) }
        let successLoadImage = loadImage.map{ $0.value }.filterNil()
        let failureLoadImage = loadImage.map{ $0.error }.filterNil()
        let saveImage = successLoadImage.flatMapLatest{ photosAlbumService.save(image: $0) }
        let failureSaveImage = saveImage.map{ $0.error }.filterNil()
        let successSaveImage = saveImage.map{ $0.value }.filterNil()
        
        let failureLoadImageMessage = MessageViewModelImpl.error(description: Strings.Imageviewer.failureLoadImage)
        let failureSaveImageMessage = MessageViewModelImpl.error(description: Strings.Imageviewer.failureSaveImage)
        let successSaveImageMessage = MessageViewModelImpl(title: Strings.Imageviewer.SuccessSaveImage.title, description: Strings.Imageviewer.SuccessSaveImage.description)
        messageViewModel = .merge(
            failureLoadImage.asDriver(onErrorJustReturn: ImageLoaderServiceError.unknown).map(to: failureLoadImageMessage),
            failureSaveImage.asDriver(onErrorJustReturn: PhotosAlbumServiceError.unknown).map(to: failureSaveImageMessage),
            successSaveImage.asDriver(onErrorJustReturn: ()).map(to: successSaveImageMessage)
        )
        shouldClose = closeTrigger.asDriver(onErrorJustReturn: ())
        shouldOpenURL = browserTrigger.asDriver(onErrorJustReturn: ()).map(to: imageURL)
        
        let appSettings = PublishSubject<Void>()
        let givePermissions = AlertActionViewModelImpl(title: Strings.Imageviewer.CameraDenied.permissions, action: appSettings)
        let cancel = AlertActionViewModelImpl(title: Strings.Imageviewer.CameraDenied.cancel, style: .destructive)
        let alertVM = AlertViewModelImpl(
            title: Strings.Imageviewer.CameraDenied.title,
            message: Strings.Imageviewer.CameraDenied.message,
            actions: [givePermissions, cancel]
        )
        alertViewModel = cameraDenied.asDriver(onErrorJustReturn: ()).map(to: alertVM)
        shouldRouteAppSettings = appSettings.asDriver(onErrorJustReturn: ()).debug("xxxxxx")
        shouldShare = shareTrigger.asDriver(onErrorJustReturn: ()).map(to: ShareItem(url: imageURL))
    }
}
