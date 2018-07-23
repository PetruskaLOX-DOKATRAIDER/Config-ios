//
//  CLLocationCoordinate2D+extensions.swift
//  Core
//
//  Created by Oleg Petrychuk on 23.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension CLLocationCoordinate2D {
    init(coordinates: Coordinates) {
        self.init(latitude: coordinates.lat, longitude: coordinates.lng)
    }
}
