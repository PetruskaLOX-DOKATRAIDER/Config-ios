//
//  AppDelegate.swift
//  Config
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Core
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private lazy var container: DependencyContainer = {
        return DependencyContainer().registerSeparateModules().registerAll()
    }()
    private lazy var router: Router = {
        //swiftlint:disable:next force_try
        return try! self.container.resolve()
    }()
    private lazy var viewModel: AppViewModel = {
        //swiftlint:disable:next force_try
        return try! self.container.resolve()
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if NSClassFromString("XCTestCase") != nil { return true }
        FirebaseApp.configure()
        UIViewController.rx.onViewDidLoad().bind(onNext: { Debugger.init($0) }).disposed(by: rx.disposeBag)
        viewModel.shouldRouteApp.map{ [router] in router.tutorial() }.setAsRoot().disposed(by: rx.disposeBag)
        viewModel.shouldRouteTutorial.map{ [router] in router.tutorial() }.setAsRoot().disposed(by: rx.disposeBag)
        viewModel.didBecomeActiveTrigger.onNext(())
        return true
    }
}
