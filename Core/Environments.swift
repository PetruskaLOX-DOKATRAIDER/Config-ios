//
//  Environments.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol AppEnvironment: AutoMockable {
    var apiURL: URL { get }
    var appVersion: String { get }
    var isDebug: Bool { get }
    var appStoreURL: URL { get }
    var donateURL: URL { get }
    var skinsApiURL: URL { get }
    var skinsCoverImageApiURL: URL { get }
}
