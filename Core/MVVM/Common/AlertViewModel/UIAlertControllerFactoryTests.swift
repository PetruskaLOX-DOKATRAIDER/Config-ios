//
//  UIAlertControllerFactoryTests.swift
//  Core
//
//  Created by Oleg Petrychuk on 13.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TestsHelper

class UIAlertControllerFactoryTests: BaseTestCase {
    override func spec() {
        describe("UIAlertControllerFactory") {
            describe("when create UIAlertController", {
                context("with some AlertViewModel") {
                    it("should return valid UIAlertController", closure: {
                        let title = String.random()
                        let style = AlertViewModelStyle.actionSheet
                        let action1Title = String.random()
                        let action2Title = String.random()
                        let action1 = AlertActionViewModelImpl(title: action1Title, style: .cancel)
                        let action2 = AlertActionViewModelImpl(title: action2Title, style: .destructive)
                        let actions = [action1, action2]
                        let vm = AlertViewModelImpl(title: title, message: nil, style: style, actions: actions)
                        
                        let alert = UIAlertControllerFactory.alertController(fromViewModelAlert: vm)
                        expect(alert.title).to(equal(title))
                        expect(alert.message).to(beNil())
                        expect(alert.preferredStyle).to(equal(UIAlertControllerStyle.actionSheet))
                        expect(alert.actions.count).to(equal(actions.count))
                        expect(alert.actions.first?.title).to(equal(action1Title))
                        expect(alert.actions.first?.style).to(equal(.cancel))
                        expect(alert.actions.last?.title).to(equal(action2Title))
                        expect(alert.actions.last?.style).to(equal(.destructive))
                    })
                }
            })
            describe("when Alert button tapped", {
                it("should call notify AlertActionVM", closure: {
                    let actionCalled = BehaviorRelay(value: false)
                    let actionPS = PublishSubject<Void>()
                    actionPS.asDriver(onErrorJustReturn: ()).map(to: true).drive(actionCalled).disposed(by: self.rx.disposeBag)
                    let vm = AlertViewModelImpl(actions: [AlertActionViewModelImpl(title: "", action: actionPS)])
                    
                    let alert = UIAlertControllerFactory.alertController(fromViewModelAlert: vm)
                    alert.tapButton(at: 0)
                    try? expect(actionCalled.toBlocking().first()).to(beTruthy())
                })
            })
        }
    }
}
