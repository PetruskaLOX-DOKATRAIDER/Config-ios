//
//  ProfileEmailItemViewModelTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class ProfileEmailItemViewModelTests: BaseTestCase {
    override func spec() {
        describe("ProfileEmailItemViewModel") {
            let userStorage = UserStorageMock(isOnboardingPassed: BehaviorRelay(value: false), email: BehaviorRelay(value: nil))
            
            describe("when email text") {
                context("and retrieving data") {
                    it("should return email") {
                        let email = String.random()
                        userStorage.email.accept(email)
                        
                        let sut = ProfileEmailItemViewModelImpl(userStorage: userStorage)
                
                        expect(sut.emailVM.text.value).to(equal(email))
                    }
                }
                
                context("and retrieving empty data") {
                    it("should return empty email") {
                        userStorage.email.accept(nil)
                        
                        let sut = ProfileEmailItemViewModelImpl(userStorage: userStorage)
                        
                        expect(sut.emailVM.text.value).to(beEmpty())
                    }
                }
            }
            
            describe("when calling save did trigger") {
                it("should save email in storage") {
                    userStorage.email.accept(String.random())
                    let sut = ProfileEmailItemViewModelImpl(userStorage: userStorage)
                    let email = String.random()
                    sut.emailVM.text.accept(email)
                    
                    sut.saveTrigger.onNext(())
                    
                    expect(userStorage.email.value).to(equal(email))
                }
            }
        }
    }
}
