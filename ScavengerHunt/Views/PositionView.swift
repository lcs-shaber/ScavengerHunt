//
//  CurrentPositionView.swift
//  ScavengerHunt
//
//  Created by Russell Gordon on 2024-09-30.
//

import CoreLocation
import MapKit
import SwiftUI

struct PositionView: View {
    
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
    
    // Used to track entry to regions
    @State var positionViewModel = PositionViewModel()
    
    // Used to track progress through targets
    @State var targetsViewModel = TargetsViewModel()
    
    // MARK: Computed properties
    var body: some View {
        ZStack {
            Map(
                coordinateRegion: $region,
                showsUserLocation: true,
                userTrackingMode: .constant(.follow)
            )
            .onAppear {
                locationManager.requestWhenInUseAuthorization()
            }
            .edgesIgnoringSafeArea(.all)

            VStack {
                
                Rectangle()
                    .foregroundStyle(.black)
                    .aspectRatio(3.0/1.0, contentMode: .fit)
                    .overlay {
                        VStack {
                            
                            Spacer()
                            
                            Text("Location manager: \(positionViewModel.location?.description ?? "No Location Provided!")")
                                .foregroundStyle(.white)
                                .padding()
                        }
                        
                    }
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)

        }
        // Show a sheet when we enter the desired region
        .sheet(isPresented: $positionViewModel.shouldShowQuizSheet) {
            Text("You made it!")
        }
        .presentationDetents([.medium, .fraction(0.25)])
        .task {
            try? await positionViewModel.requestUserAuthorization()
            await positionViewModel.monitor(
                target: targetsViewModel.getCurrentTarget()
            )
            try? await positionViewModel.startCurrentLocationUpdates()
        }
    }
}

#Preview {
    PositionView()
}
