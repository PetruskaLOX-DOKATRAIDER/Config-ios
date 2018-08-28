//
//  AppEnvironment.swift
//  Config
//
//  Created by Oleg Petrychuk on 23.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

private let firstVersion = "0.0.0"

public enum AppEnvironmentImpl: AppEnvironment {
    case develop(info: [String : Any])
    case staging(info: [String : Any])
    case production(info: [String : Any])
    
    public var info: [String : Any] {
        switch self {
        case .develop(let info): return info
        case .staging(let info): return info
        case .production(let info): return info
        }
    }
    
    public init(info: [String : Any] = Bundle.main.infoDictionary ?? [:]) {
        let plistValue = info["Configuration"] as? String ?? ""
        if plistValue.lowercased().contains("staging") { self = .staging(info: info) } else if plistValue.lowercased().contains("production") { self = .production(info: info) } else { self = .develop(info: info) }
    }
    
    public var apiURL: URL {
        switch self {
        case .develop: return URL(string: "https://cscoconfigs.firebaseio.com/") ?? URL(fileURLWithPath: "")
        case .staging: return URL(string: "https://cscoconfigs.firebaseio.com/") ?? URL(fileURLWithPath: "")
        case .production: return URL(string: "https://cscoconfigs.firebaseio.com/") ?? URL(fileURLWithPath: "")
        }
    }
    
    public var appVersion: String {
        return info["CFBundleShortVersionString"] as? String ?? firstVersion
    }
    
    public var isDebug: Bool {
        guard let config = info["Configuration"] as? String else { return false }
        return config.lowercased().contains("debug")
    }
    
    public var appStoreURL: URL {
        if self.appVersion == firstVersion {
            return URL(string: "https://www.google.com") ?? URL(fileURLWithPath: "")
        } else {
            return URL(string: "") ?? URL(fileURLWithPath: "")
        }
    }
    
    public var donateURL: URL {
        return URL(string: "https://www.google.com") ?? URL(fileURLWithPath: "")
    }
    
    public var skinsApiURL: URL {
        return URL(string: "wss://wsn.dota2.net/wsn/") ?? URL(fileURLWithPath: "")
    }
    
    public var skinsCoverImageApiURL: URL {
        return URL(string: "https://cdn.csgo.com/") ?? URL(fileURLWithPath: "")
    }
    
    public var flurryID: String {
        return "X4ZC7TDS9HQQ7Q5XQQ"
    }
}
