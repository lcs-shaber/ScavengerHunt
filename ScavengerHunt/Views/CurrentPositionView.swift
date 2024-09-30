//
//  CurrentPositionView.swift
//  ScavengerHunt
//
//  Created by Russell Gordon on 2024-09-30.
//

import CoreLocation
import MapKit
import SwiftUI

// NOTE: Source for how to show current position
//       https://medium.com/@pblanesp/how-to-display-a-map-and-track-the-users-location-in-swiftui-7d288cdb747e

struct CurrentPositionView: View {
    
    // MARK: Stored properties
    let locationManager = CLLocationManager()
    
    // Initial region to show
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 44.44963,
            longitude: -78.26515
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.01,
            longitudeDelta: 0.01
        )
    )
    
    // MARK: Computed properties
    var body: some View {
        
        Map(
            coordinateRegion: $region,
            showsUserLocation: true,
            userTrackingMode: .constant(.follow)
        )
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                locationManager.requestWhenInUseAuthorization()
            }
    }
}

#Preview {
    CurrentPositionView()
}
