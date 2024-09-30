//
//  Positions.swift
//  ScavengerHunt
//
//  Created by Russell Gordon on 2024-09-30.
//

import CoreLocation
import Foundation

struct TargetRegion {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let radius: CLLocationDistance
    let identifier: String
    let question: String
    let answer: String
    var completed: Bool
}
