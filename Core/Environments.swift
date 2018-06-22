//
//  Environments.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// MARK: Protocol

public protocol AppEnvironment: AutoMockable {
    var apiURL : String { get }
    var appVersion: String { get }
    var isDebug: Bool { get }
}

// MARK: Implementation

private enum AppEnvironmentImpl: AppEnvironment {
    case develop(info: [String : Any])
    case staging(info: [String : Any])
    case production(info: [String : Any])
    
    var info: [String : Any] {
        switch self {
        case .develop(let info): return info
        case .staging(let info): return info
        case .production(let info): return info
        }
    }
    
    init(info: [String : Any]) {
        let plistValue = info["Configuration"] as? String ?? ""
        if plistValue.lowercased().contains("staging") { self = .staging(info: info) } else if plistValue.lowercased().contains("production") { self = .production(info: info) } else { self = .develop(info: info) }
    }
    
    var apiURL: String {
        switch self {
        case .develop: return "https://cscoconfigs.firebaseio.com/"
        case .staging: return "https://cscoconfigs.firebaseio.com/"
        case .production: return "https://cscoconfigs.firebaseio.com/"
        }
    }
    
    var appVersion: String {
        return info["CFBundleShortVersionString"] as? String ?? "0.0.0"
    }
    
    var isDebug: Bool {
        guard let config = info["Configuration"] as? String else { return false }
        return config.lowercased().contains("debug")
    }
}

// MARK: Factory

public class AppEnvironmentFactory {
    public static func `default`(
        info: [String : Any] = Bundle.main.infoDictionary ?? [:]
        ) -> AppEnvironment {
        return AppEnvironmentImpl(info: info)
    }
}
