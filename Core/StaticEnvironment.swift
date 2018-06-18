//
//  StaticEnvironment.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public enum Formatters {
    public static var iso8601: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }
}


private final class BundleAnchor {}
extension Bundle {
    public static var core: Bundle {
        return Bundle(for: BundleAnchor.self)
    }
}

extension Bundle {
    public func image(named: String) -> UIImage? {
        return UIImage(named: named, in: self, compatibleWith: nil)
    }
}
