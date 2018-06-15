//
//  Environments.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol AutoMockable {}

public protocol ServerEnvironmentType: AutoMockable {
    var serverURL: String { get }
    var apiURL : String { get }
}

public protocol AppEnvironmentType: AutoMockable {
    var updateVersionLink: URL? { get }
    var appVersion: String { get }
    var isDebug: Bool { get }
}
