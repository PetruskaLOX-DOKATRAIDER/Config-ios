//
//  ReachabilityService.swift
//  Core
//
//  Created by Oleg Petrychuk on 11.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Reachability

public enum Connection: String {
    case none
    case wifi
    case cellular
    
    fileprivate init(connection: Reachability.Connection?) {
        if let connect = connection {
            switch connect {
            case .none: self = .none
            case .wifi: self = .wifi
            case .cellular: self = .cellular
            }
        } else {
            self = .none
        }
    }
}

public protocol ReachabilityService: AutoMockable {
    var connection: Connection { get }
}

public final class ReachabilityServiceImpl: ReachabilityService {
    private let reachability: Reachability?
    
    public init(reachability: Reachability? = Reachability()) {
        self.reachability = reachability
    }
    
    public var connection: Connection {
        return Connection(connection: reachability?.connection)
    }
}
