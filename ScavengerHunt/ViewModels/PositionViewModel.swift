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
    
    var location: CLLocation? = nil
    var isInSeikoStore = false
    var shouldShowGoodByeSheet = false
    private let regionIdentifier = "SeikoRegion"
    
    private let locationManager = CLLocationManager()
    private var monitor: CLMonitor? // we need a new object here
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestUserAuthorization() async throws {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startCurrentLocationUpdates() async throws {
        for try await locationUpdate in CLLocationUpdate.liveUpdates() {
            guard let location = locationUpdate.location else { return }
            
            self.location = location
        }
    }
    
    func monitorSeikoStoreRegion() async {
        
        if monitor == nil {
            monitor = await CLMonitor("MonitorID")
        }
        
        await monitor?.add(
            CLMonitor.CircularGeographicCondition(
                center: CLLocationCoordinate2D(latitude: 44.42902, longitude: -78.26495),
                radius: 20
            ),
            identifier: regionIdentifier,
            assuming: .unsatisfied
        )
        
        Task {
            
            guard let monitor else {
                return
            }
            
            for try await event in await monitor.events {
                    switch event.state {
                    case .satisfied: // you will receive the callback here when user ENTER any of the registered regions. 
                        enterSeikoStoreRegion()
                    case .unknown, .unsatisfied: // you will receive the callback here when user EXIT any of the registered regions.                          
                        exitSeikoStoreRegion()
                    default:
                        print("No Location Registered")
                    }
            }
        }
    }
    
    func enterSeikoStoreRegion() {
        isInSeikoStore = true
        print("didEnterRegion run")
    }
    
    func exitSeikoStoreRegion() {
        shouldShowGoodByeSheet = true
        isInSeikoStore = false
        print("didExitRegion run")
    }
    
}
