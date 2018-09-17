//
//  StorageSetupViewModelTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class StorageSetupViewModelTests: BaseTestCase {
    override func spec() {
        describe("StorageSetupViewModel") {
            
            let imageLoaderService = ImageLoaderServiceMock()
            var sut: StorageSetupViewModel!
            beforeEach {
                sut = StorageSetupViewModelImpl(imageLoaderService: imageLoaderService)
            }
            
            describe("when calling clear cache did trigger") {
                it("should ask to clear cache") {
                    let observer = self.scheduler.createObserver(Void.self)
                    sut.cacheСleared.drive(observer).disposed(by: self.disposeBag)
                    
                    sut.clearTrigger.onNext(())
                    
                    expect(imageLoaderService.clearCacheCalled).to(beTruthy())
                }
                
                it("should notify about cache clearing") {
                    let observer = self.scheduler.createObserver(Void.self)
                    sut.cacheСleared.drive(observer).disposed(by: self.disposeBag)
                    
                    sut.clearTrigger.onNext(())
                    
                    expect(observer.events.count).to(equal(1))
                }
            }
        }
    }
}
