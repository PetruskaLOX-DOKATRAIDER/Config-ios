//
//  PushNotificationsViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import UserNotifications
import TRON
import SwiftyJSON

public protocol PushNotificationsHandlerType {
    var deviceTokenTrigger: PublishRelay<Data> { get }
    var userInfoTrigger: PublishRelay<[AnyHashable : Any]> { get }
    var routeToNotes: Driver<String> { get }
}

open class PushNotificationsHandler: PushNotificationsHandlerType, ReactiveCompatible {
    open let deviceTokenTrigger = PublishRelay<Data>()
    open let userInfoTrigger = PublishRelay<[AnyHashable : Any]>()
    open let routeToNotes: Driver<String>
    
    public init(service: PushTokenServiceType, sessionStorage: SessionStorageType, register: @escaping () -> Void = {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                if granted {
                    // registration callback can be invoked on background thread but "registerForRemoteNotifications" requires main thread
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                } else if let error = error {
                    print(error)
                }
            }
        }) {
        routeToNotes = userInfoTrigger.asDriver().map{ JSON($0)["order_id"].stringValue }.filterEmpty()
        
        sessionStorage.session.asObservable().filterNil().once().toVoid().bind(onNext: register).disposed(by: rx.disposeBag)
        let pushToken = deviceTokenTrigger.asDriver().map{ $0.map{ String(format: "%02X", $0) }.joined() }
        let appToken = sessionStorage.session.asDriver()
        Driver.combineLatest(pushToken, appToken).filter{ $0.1 != nil }.map{ $0.0 }
            .flatMap(service.register).drive().disposed(by: rx.disposeBag)
    }
}
