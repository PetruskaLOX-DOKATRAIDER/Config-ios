//
//  ImageViewerViewModelTests.swift
//  Config
//
//  Created by Oleg Petrychuk on 02.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class ImageViewerViewModelTests: BaseTestCase {
    override func spec() {
        describe("ImageViewerViewModel") {
            let title = String.random()
            let imageURL = URL.new()
            let imageLoaderService = ImageLoaderServiceMock()
            let photosAlbumService = PhotosAlbumServiceMock()
            let cameraService = CameraServiceMock(cameraAuthorizationStatus: .notDetermined)
            var sut: ImageViewerViewModel!
            
            beforeEach {
                sut = ImageViewerViewModelImpl(title: title, imageURL: imageURL, imageLoaderService: imageLoaderService, photosAlbumService: photosAlbumService, cameraService: cameraService)
            }
            
            describe("when ask title and image") {
                it("should return passed values") {
                    try? expect(sut.title.toBlocking().first()).to(equal(title))
                    try? expect(sut.imageURL.toBlocking().first()).to(equal(imageURL))
                }
            }
            
            describe("when calling save did trigger") {
                context("and camera is denied") {
                    it("should show camera is denied alert") {
                        let observer = self.scheduler.createObserver(AlertViewModel.self)
                        sut.alertViewModel.drive(observer).disposed(by: self.disposeBag)
                        cameraService.cameraAuthorizationStatus = .denied
        
                        sut.saveTrigger.onNext(())
        
                        try? expect(sut.alertViewModel.toBlocking().first()?.title).to(equal(Strings.Imageviewer.CameraDenied.title))
                        try? expect(sut.alertViewModel.toBlocking().first()?.actions.count).to(equal(2))
                    }
                }
            }
            
            describe("when calling save did trigger") {
                context("and received load image error") {
                    it("should show load image error message") {
                        let observer = self.scheduler.createObserver(MessageViewModel.self)
                        sut.messageViewModel.drive(observer).disposed(by: self.disposeBag)
                        cameraService.cameraAuthorizationStatus = .authorized
                        imageLoaderService.loadImageWithURLReturnValue = .just(Result(error: .unknown))
                        
                        sut.saveTrigger.onNext(())
                        
                        try? expect(sut.messageViewModel.toBlocking().first()?.description.toBlocking().first()).to(equal(Strings.Imageviewer.failureLoadImage))
                    }
                }
            }
            
            describe("when calling save did trigger") {
                context("and successfully saved image") {
                    it("should show success message") {
                        let observer = self.scheduler.createObserver(MessageViewModel.self)
                        sut.messageViewModel.drive(observer).disposed(by: self.disposeBag)
                        cameraService.cameraAuthorizationStatus = .authorized
                        imageLoaderService.loadImageWithURLReturnValue = .just(Result(value: Images.EventFilters.date))
                        photosAlbumService.saveImageReturnValue = .just(Result(value: ()))
                        
                        sut.saveTrigger.onNext(())
                        
                        try? expect(sut.messageViewModel.toBlocking().first()?.title.toBlocking().first()).to(equal(Strings.Imageviewer.SuccessSaveImage.title))
                    }
                }
                
                context("and failed to sav image") {
                    it("should show save error message") {
                        let observer = self.scheduler.createObserver(MessageViewModel.self)
                        sut.messageViewModel.drive(observer).disposed(by: self.disposeBag)
                        cameraService.cameraAuthorizationStatus = .authorized
                        imageLoaderService.loadImageWithURLReturnValue = .just(Result(error: .unknown))
                        photosAlbumService.saveImageReturnValue = .just(Result(error: .unknown))
                        
                        sut.saveTrigger.onNext(())
                        
                        try? expect(sut.messageViewModel.toBlocking().first()?.description.toBlocking().first()).to(equal(Strings.Imageviewer.failureLoadImage ))
                    }
                }
            }
            
            describe("when calling save did trigger") {
                describe("and show camera is denied alert") {
                    context("and app settings did trigger") {
                        it("should go to app settings") {
                            let alertObserver = self.scheduler.createObserver(AlertViewModel.self)
                            sut.alertViewModel.drive(alertObserver).disposed(by: self.disposeBag)
                            let appSettingsObserver = self.scheduler.createObserver(Void.self)
                            sut.shouldRouteAppSettings.drive(appSettingsObserver).disposed(by: self.disposeBag)
                            cameraService.cameraAuthorizationStatus = .denied
                            
                            sut.saveTrigger.onNext(())
                            try? sut.alertViewModel.toBlocking().first()?.actions.first?.action?.onNext(())
                            
                            expect(appSettingsObserver.events.count).to(equal(1))
                        }
                    }
                }
            }
            
            describe("when calling close did trigger") {
                it("should close") {
                    let observer = self.scheduler.createObserver(Void.self)
                    sut.shouldClose.drive(observer).disposed(by: self.disposeBag)
                    
                    sut.closeTrigger.onNext(())
                    
                    expect(observer.events.count).to(equal(1))
                }
            }
            
            describe("when calling browser did trigger") {
                it("should open passed image") {
                    let observer = self.scheduler.createObserver(URL.self)
                    sut.shouldOpenURL.drive(observer).disposed(by: self.disposeBag)
                    
                    sut.browserTrigger.onNext(())
                    
                    try? expect(sut.shouldOpenURL.toBlocking().first()).to(equal(imageURL))
                }
            }
            
            describe("when calling share did trigger") {
                it("should share passed image") {
                    let observer = self.scheduler.createObserver(ShareItem.self)
                    sut.shouldShare.drive(observer).disposed(by: self.disposeBag)
                    
                    sut.shareTrigger.onNext(())
                    
                    try? expect(sut.shouldShare.map{ $0.url }.filterNil().toBlocking().first()).to(equal(imageURL))
                }
            }
        }
    }
}
