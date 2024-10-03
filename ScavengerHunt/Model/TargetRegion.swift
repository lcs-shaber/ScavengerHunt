//
//  Positions.swift
//  ScavengerHunt
//
//  Created by Russell Gordon on 2024-09-30.
//

import CoreLocation
import Foundation

@Observable
class TargetRegion: Identifiable, Equatable {

    let id = UUID()
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let radius: CLLocationDistance
    let identifier: String
    let question: String
    let answer: String
    var completed: Bool
    
    internal init(
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees,
        radius: CLLocationDistance,
        identifier: String,
        question: String,
        answer: String,
        completed: Bool
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.identifier = identifier
        self.question = question
        self.answer = answer
        self.completed = completed
    }
    
    static func == (lhs: TargetRegion, rhs: TargetRegion) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    
}
