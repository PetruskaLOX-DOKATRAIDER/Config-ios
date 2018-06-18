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
