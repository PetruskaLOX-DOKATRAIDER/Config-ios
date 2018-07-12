//
//  Bundle+extensions.swift
//  Core
//
//  Created by Oleg Petrychuk on 12.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

private final class BundleAnchor {}
extension Bundle {
    public static var core: Bundle {
        return Bundle(for: BundleAnchor.self)
    }
    
    public func image(named: String) -> UIImage? {
        return UIImage(named: named, in: self, compatibleWith: nil)
    }
    
    public var name: String {
        return object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
    }
}
