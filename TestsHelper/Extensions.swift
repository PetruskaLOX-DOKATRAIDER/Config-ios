//
//  Extensions.swift
//  TestsHelper
//
//  Created by Oleg Petrychuk on 13.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// MARK: UIAlertController

extension UIAlertController {
    public func tapButton(at index: Int) {
        if let action = actions[safe: index], let block = action.value(forKey: "handler") {
            typealias AlertHandler = @convention(block) (UIAlertAction) -> Void
            let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
            let handler = unsafeBitCast(blockPtr, to: AlertHandler.self)
            handler(self.actions[index])
        }
    }
}
