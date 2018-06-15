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

//    lazy var router: Router = {
//        //swiftlint:disable:next force_try
//        return try! self.container.resolve()
//    }()
//    lazy var viewModel: AppViewModelType = {
//        //swiftlint:disable:next force_try
//        return try! self.container.resolve()
//    }()
//    lazy var pushHandler: PushNotificationsHandlerType = {
//        //swiftlint:disable:next force_try
//        return try! self.container.resolve()
//    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if NSClassFromString("XCTestCase") != nil { return true }
        Fabric.with([Crashlytics.self])
        AppAppearence.style()
        UIViewController.rx.onViewDidLoad().bind(onNext: { Debugger($0) }).disposed(by: rx.disposeBag)
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("\n\n[AppDelegate] failed to register for PushNotifications")
    }
    
    // UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
