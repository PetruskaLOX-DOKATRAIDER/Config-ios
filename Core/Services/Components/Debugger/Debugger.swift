//
//  Debugger.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public enum Debugger {
    public static func `init`(_ obj: AnyObject, logger: @escaping (String) -> Void = { print($0) }) {
        Debugger.init(obj, trackDeinit: true, logger: logger)
    }
    public static func `init`(_ obj: AnyObject, trackDeinit: Bool, logger: @escaping (String) -> Void = { print($0) }) {
        let instance = Debugger.instance(obj)
        let type = Debugger.type(obj)
        logger("[😇init] \(type) instance: \(instance)")
        guard trackDeinit, objc_getAssociatedObject(self, AssociatedKeys.deinitDebug) == nil else { return }
        objc_setAssociatedObject(obj, &AssociatedKeys.deinitDebug, DeinitPrint(logger: logger, message: "[😈deinit] \(type) instance: \(instance)"), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate static func instance(_ obj: AnyObject) -> String {
        return "\(Unmanaged<AnyObject>.passUnretained(obj).toOpaque())"
    }
    fileprivate static func type(_ obj: AnyObject) -> String {
        return String(describing: Swift.type(of: obj))
    }
}

public class DebugPrint {
    let name: String
    let logDeinit: Bool
    let logger: (String) -> Void
    
    public init(_ name: String, logInit: Bool = true, logDeinit: Bool = true, logger: @escaping (String) -> Void = { print($0) }) {
        self.name = name
        self.logDeinit = logDeinit
        self.logger = logger
        guard logInit else { return }
        self.logger("[😇init] name: \(name) instance: \(Debugger.instance(self))")
    }
    
    deinit {
        guard logDeinit else { return }
        logger("[😈deinit] name: \(name) instance: \(Debugger.instance(self))")
    }
}

private class DeinitPrint {
    let logger: (String) -> Void
    let message: String
    
    init(logger: @escaping (String) -> Void, message: String) {
        self.logger = logger
        self.message = message
    }
    
    deinit {
        logger(message)
    }
}

private struct AssociatedKeys {
    static var deinitDebug = "object deinit debug message"
}
