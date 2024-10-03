//
//  Positions.swift
//  ScavengerHunt
//
//  Created by Russell Gordon on 2024-09-30.
//

import CoreLocation
import Foundation

struct TargetRegion: Identifiable, Hashable {
    let id = UUID()
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let radius: CLLocationDistance
    let identifier: String
    let question: String
    let answer: String
    var completed: Bool
}
