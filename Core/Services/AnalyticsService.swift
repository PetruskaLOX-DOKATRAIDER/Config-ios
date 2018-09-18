//
//  AnalyticsService.swift
//  Core
//
//  Created by Oleg Petrychuk on 27.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Flurry_iOS_SDK

public protocol AnalyticsService: AutoMockable {
    func trackFeedback(withMessage message: String)
}

public class AnalyticsServiceImpl: AnalyticsService {
    private let appEnvironment: AppEnvironment
    private let flurry: Flurry.Type
    
    public init(
        appEnvironment: AppEnvironment,
        flurry: Flurry.Type = Flurry.self
    ) {
        self.appEnvironment = appEnvironment
        self.flurry = flurry
        configureFlurry()
    }
    
    public func trackFeedback(withMessage message: String) {
        let event = "feedback"
        let parameters = ["message" : message]
        logFlurry(event: event, withParameters: parameters)
    }
    
    // MARK: Flurry
    
    private func configureFlurry() {
        let builder = FlurrySessionBuilder()
            .withAppVersion(appEnvironment.appVersion)
            .withLogLevel(FlurryLogLevelNone)
            .withCrashReporting(true)
            .withSessionContinueSeconds(10)
        flurry.startSession(appEnvironment.flurryID, with: builder)
    }
    
    private func logFlurry(event: String, withParameters parameters: [String : Any]) {
        flurry.logEvent(event, withParameters: parameters)
    }
}
