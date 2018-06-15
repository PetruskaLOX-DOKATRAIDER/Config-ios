//
//  AppViewModel.swift
//  GoDrive
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public typealias AlertData = (title: String, text: String)

public protocol AppViewModelType {
    var shouldRouteSignedIn: Driver<Void> { get }
    var shouldRouteSignedOut: Driver<Void> { get }
    var shouldAlertUnsupportedVersion: Driver<URL?> { get }
}

public final class AppViewModel: AppViewModelType, ReactiveCompatible {
    public let shouldRouteSignedIn: Driver<Void>
    public let shouldRouteSignedOut: Driver<Void>
    
    public let shouldAlertUnsupportedVersion: Driver<URL?>
    
    public init(sessionStorage: SessionStorageType, authPlugin: AuthPluginType, environment: AppEnvironmentType) {
        let sessionDriver = sessionStorage.session.asDriver().map({ $0 == nil }).distinctUntilChanged()
        shouldRouteSignedIn = sessionDriver.filter{ !$0 }.toVoid()
        shouldRouteSignedOut = sessionDriver.filter{ $0 }.toVoid()
        
        // unsupported version also produces new event in unauthorized sequence
        shouldAlertUnsupportedVersion = authPlugin.unsupported.map(to: environment.updateVersionLink).debounce(0.3)
        authPlugin.unauthorized.throttle(0.3).map(to: nil).drive(sessionStorage.session).disposed(by: rx.disposeBag)
    }
}
