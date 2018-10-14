//
//  AppEnvironment.swift
//  Config
//
//  Created by Oleg Petrychuk on 23.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public enum AppEnvironmentImpl: AppEnvironment {
    case develop(info: [String : Any])
    case staging(info: [String : Any])
    case production(info: [String : Any])
    
    public init(
        info: [String : Any] = Bundle.main.infoDictionary ?? [:]
    ) {
        let plistValue = info["Configuration"] as? String ?? ""
        if plistValue.lowercased().contains("staging") {
            self = .staging(info: info)
        } else if plistValue.lowercased().contains("production") {
            self = .production(info: info)
        } else {
            self = .develop(info: info)
        }
    }
    
    private var info: [String : Any] {
        switch self {
        case .develop(let info): return info
        case .staging(let info): return info
        case .production(let info): return info
        }
    }
    
    public var apiURL: URL {
        switch self {
        case .develop: return URL(string: "https://cscoconfigs.firebaseio.com/") ?? URL(fileURLWithPath: "")
        case .staging: return URL(string: "https://cscoconfigs.firebaseio.com/") ?? URL(fileURLWithPath: "")
        case .production: return URL(string: "https://cscoconfigs.firebaseio.com/") ?? URL(fileURLWithPath: "")
        }
    }
    
    public var appVersion: String {
        return info["CFBundleShortVersionString"] as? String ?? "0.0.0"
    }
    
    public var isDebug: Bool {
        guard let config = info["Configuration"] as? String else { return false }
        return config.lowercased().contains("debug")
    }
    
    public var appStoreURL: URL {
        let google = URL(string: "https://www.google.com/") ?? URL(fileURLWithPath: "")
        let appStore = URL(string: "") ?? URL(fileURLWithPath: "")
        return appVersion == "0.0.0" ? google : appStore
    }
    
    public var donateURL: URL {
        return URL(string: "https://steamcommunity.com/groups/1TapElite") ?? URL(fileURLWithPath: "")
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
