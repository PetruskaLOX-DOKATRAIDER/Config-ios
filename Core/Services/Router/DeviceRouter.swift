//
//  DeviceRouter.swift
//  Core
//
//  Created by Oleg Petrychuk on 02.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public enum DeviceRouterError: Error {
    case settingsURLNotFound
    case cantOpenURL
}

public protocol DeviceRouter: AutoMockable {
    func openSettings() throws
    func open(url: URL) throws
}

public final class DeviceRouterImpl: DeviceRouter {
    private let application: UIApplication
    
    public init(application: UIApplication = .shared) {
        self.application = application
    }
    
    public func openSettings() throws {
        guard let url = URL(string: UIApplicationOpenSettingsURLString) else { throw DeviceRouterError.settingsURLNotFound }
        try? open(url: url)
    }
    
    public func open(url: URL) throws {
        guard application.canOpenURL(url) else { throw DeviceRouterError.cantOpenURL }
        application.open(url)
    }
}
