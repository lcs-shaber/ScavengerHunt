//
//  PositionViewModel.swift
//  ScavengerHunt
//
//  Created by Russell Gordon on 2024-09-30.
//

import SwiftUI
import CoreLocation

@Observable
class PositionViewModel: NSObject, CLLocationManagerDelegate {
    
    // Stores user's current location, once tracking starts
    var location: CLLocation? = nil
    
    // Is the user within the current target region?
    var isInCurrentTargetRegion = false
    
    // Whether to show the quiz for target region
    var shouldShowQuizSheet = false
    
    // Invokes the Apple framework that permits location tracking
    private let locationManager = CLLocationManager()
    
    // An object that monitors the conditions we add to it
    private var monitor: CLMonitor?
    
    // Initialize this view model
    override init() {
        
        super.init()
        
        // This class, itself, will handle update events when location changes
        locationManager.delegate = self
        
        // Get as much detail as possible for current location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    // Ask for permission to track user location
    func requestUserAuthorization() async throws {
        locationManager.requestWhenInUseAuthorization()
    }
    
    // Starts user location tracking
    func startCurrentLocationUpdates() async throws {
        
        // Loops and receives updates when the user's location changes
        // This runs asynchronously, meaning it "waits" for changes to occur, then handles them as they occur
        for try await locationUpdate in CLLocationUpdate.liveUpdates() {
            guard let location = locationUpdate.location else { return }
            
            // Update the user's current location
            self.location = location
        }
    }
    
    func monitor(target: TargetRegion) async {
        
        // Create a monitor to keep track of location
        if monitor == nil {
            monitor = await CLMonitor("MonitorID")
        }
        
        // Add the current target region to the list of regions to monitor
        await monitor?.add(
            CLMonitor.CircularGeographicCondition(
                center: CLLocationCoordinate2D(
                    latitude: target.latitude,
                    longitude: target.longitude
                ),
                radius: target.radius
            ),
            identifier: target.identifier,
            assuming: .unsatisfied
        )
        
        Task {
            
            guard let monitor else {
                return
            }
            
            for try await event in await monitor.events {
                switch event.state {
                case .satisfied: // you will receive the callback here when user ENTER any of the registered regions.
                    enteredTargetRegion()
                case .unknown, .unsatisfied: // you will receive the callback here when user EXIT any of the registered regions.
                    leftCurrentTargetRegion()
                default:
                    print("No Location Registered")
                }
            }
        }
    }
    
    func enteredTargetRegion() {
        isInCurrentTargetRegion = true
        shouldShowQuizSheet = true
        print("enteredTargetRegion has been run")
    }
    
    func leftCurrentTargetRegion() {
        isInCurrentTargetRegion = false
        print("leftCurrentTargetRegion run")
    }
    
}
