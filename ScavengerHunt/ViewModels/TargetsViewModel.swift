//
//  TargetsViewModel.swift
//  ScavengerHunt
//
//  Created by Russell Gordon on 2024-09-30.
//

import SwiftUI

@Observable
class TargetsViewModel {
    
    // MARK: Stored properties
    var currentTargetIndex: Int = 0
    
    var targets: [TargetRegion] = [
        
        TargetRegion( // 44.43832° N, 78.26718° W
            latitude: 44.43832,
            longitude: -78.26718,
            radius: 8,
            identifier: "John Runza's House",
            question: "He guided the flock at LCS for many years – what is the name of the house he lives in?",
            answer: "Hillcot",
            completed: false
                    ),
        
        TargetRegion( // 44.43984° N, 78.26474° W
            latitude: 44.43991210,
            longitude: -78.26460133,
            radius: 8,
            identifier: "Academic Block Sign",
            question: "What family sponsored the construction of the Academic Block?",
            answer: "Desmarais",
            completed: false
                    ),
        
        TargetRegion(
            latitude: 44.43728,
            longitude: -78.26820,
            radius: 8,
            identifier: "Uplands House",
            question: "One of the newest houses with geothermal heating",
            answer: "Uplands",
            completed: false
        ),
        
        TargetRegion(
            latitude: 44.43800,
            longitude: -78.26579,
            radius: 8,
            identifier: "Gate house",
            question: "the tiny house when you drive onto campus - what colour is the fence?",
            answer: "Green",
            completed: false
        ),
        
        TargetRegion(
            latitude: 44.43910514,
            longitude: -78.26751465,
            radius: 8,
            identifier: "Ryder House",
            question: "What house has a polar bear as their mascot?",
            answer: "Ryder",
            completed: false
        ),
        
        TargetRegion(
            latitude: 44.43963,
            longitude: -78.26499,
            radius: 8,
            identifier: "theater lobby",
            question: "Where are we going to see the performances in the school?",
            answer: "Theater",
            completed: false
        ),
        
        TargetRegion(//44.44050° N, 78.26741° W
            latitude: 44.44050,
            longitude: -78.26741,
            radius: 8,
            identifier: "Parent House",
            question: "Which is the newest girl's house?",
            answer: "Parent",
            completed: false
        ),

      TargetRegion(latitude: 44.44051,
                    longitude: -78.26611,
                    radius: 8,
                    identifier: "The ODR",
                    question: "The only facility that's open for one season - what is the name of this facility?",
                    answer: "Bob Armstrong Rink",
                    completed: false
        ),

      TargetRegion(
                            latitude: 44.43775626,
                            longitude: -78.26757131,
                            radius: 8,
                            identifier: "Sign infront of thw House",
                            question: "What is the 3rd newest house built on campus?",
                            answer: "Cooper House",
                            completed: false
                        )
    ]
    
    // MARK: Functions
    func getCurrentTarget() -> TargetRegion {
        return targets[currentTargetIndex]
    }
    
}
