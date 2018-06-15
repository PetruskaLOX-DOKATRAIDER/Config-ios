//
//  AppEnvironment.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Core

enum Configuration {
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
    init(info: [String : Any] = Bundle.main.infoDictionary ?? [:]) {
        let plistValue = info["Configuration"] as? String ?? ""
        if plistValue.lowercased().contains("staging") { self = .staging(info: info) } else if plistValue.lowercased().contains("production") { self = .production(info: info) } else { self = .develop(info: info) }
    }
}

extension Configuration: ServerEnvironmentType {
    var serverURL: String {
        switch self {
        case .develop: return ""
        case .staging: return ""
        case .production: return ""
        }
    }
    
    var apiURL: String { return serverURL + "/api" }
}

extension Configuration: AppEnvironmentType {
    var appVersion: String {
        return info["CFBundleShortVersionString"] as? String ?? "0.0.0"
    }
    
    var updateVersionLink: URL? {
        return nil
    }
    
    var isDebug: Bool {
        guard let config = info["Configuration"] as? String else { return false }
        return config.lowercased().contains("debug")
    }
}
