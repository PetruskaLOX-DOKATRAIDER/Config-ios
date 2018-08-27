//
//  AnalyticsService.swift
//  Core
//
//  Created by Oleg Petrychuk on 27.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Firebase

public protocol AnalyticsService: AutoMockable {
    func trackFeedback(withMessage message: String)
}

public class AnalyticsServiceImpl: AnalyticsService {
    private let analytics: Analytics.Type
    
    public init(analytics: Analytics.Type = Analytics.self) {
        self.analytics = analytics
    }
    
    public func trackFeedback(withMessage message: String) {
//        analytics.logEvent("feedback", parameters:
//            ["message" : message]
//        )
    }
}
