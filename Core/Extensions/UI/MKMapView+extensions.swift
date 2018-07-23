//
//  MKMapView+extensions.swift
//  Core
//
//  Created by Oleg Petrychuk on 23.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

extension MKMapView {
    func deselectAllAnnotation(animated: Bool = false) {
        annotations.forEach{ deselectAnnotation($0, animated: false) }
    }
    
    func setCurrentRegion(withCoordinate coordinate: CLLocationCoordinate2D, animated: Bool = true) {
        let newRegion = MKCoordinateRegion(center: coordinate, span: region.span)
        setRegion(newRegion, animated: true)
    }
}
