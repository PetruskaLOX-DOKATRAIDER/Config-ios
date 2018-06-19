//
//  AppDelegate.swift
//  Config
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Core
import UserNotifications
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private let viewModel = AppViewModelFactory.default()
    private let navigator: Navigator
    
    override init() {
        navigator = NavigatorFactory.default(appViewModel: viewModel)
        super.init()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if NSClassFromString("XCTestCase") != nil { return true }
        //Fabric.with([Crashlytics.self])
        UIViewController.rx.onViewDidLoad().bind(onNext: { Debugger($0) }).disposed(by: rx.disposeBag)
        viewModel.didBecomeActiveTrigger.onNext(())
        return true
    }
}
