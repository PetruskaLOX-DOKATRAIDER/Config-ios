//
//  Bundle+extensions.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 12.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

private final class BundleAnchor {}
extension Bundle {
    public static var coredata: Bundle {
        return Bundle(for: BundleAnchor.self)
    }
}

