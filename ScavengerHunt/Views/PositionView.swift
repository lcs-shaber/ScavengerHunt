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
    @Binding var currentTarget: TargetRegion
    
    // Used to track current answer
    @State var currentAnswer = ""
    
    // Used to track whether question is active
    @State var questionIsActive = false
    
    // MARK: Computed properties
    
    // Distance to target from current location
    var distanceToTarget: CLLocationDistance? {

        // positionViewModel.location is an instance of CLLocation and that built-in type (part of Core Location) provides a method named distance that finds the distance between two points
        guard let targetLocation = positionViewModel.location else {
            return nil
        }
        
        let distance = targetLocation.distance(from: CLLocation(latitude: currentTarget.latitude, longitude: currentTarget.longitude))
        
        return distance

    }
    
    var distanceToTargetDescription: String {
        
        // positionViewModel.location is an instance of CLLocation and that built-in type (part of Core Location) provides a method named distance that finds the distance between two points
        guard let distanceToTarget = distanceToTarget else {
            return "unknown"
        }
                
        return String(distanceToTarget.formatted(.number.precision(.fractionLength(1)))) + " m"
        
    }
    
    // Color to use for showing distance to target
    var distanceToTargetColor: Color {
        guard let distanceToTarget = distanceToTarget else {
            return Color(hue: 240.0/360.0, saturation: 0.8, brightness: 0.9)
        }
        
        switch distanceToTarget {
        case 1000...:
            return Color(hue: 240.0/360.0, saturation: 0.8, brightness: 0.9)
        case 500...1000:
            return Color(hue: 280.0/360.0, saturation: 0.8, brightness: 0.9)
        case 250...500:
            return Color(hue: 300.0/360.0, saturation: 0.8, brightness: 0.9)
        case 125...250:
            return Color(hue: 320.0/360.0, saturation: 0.8, brightness: 0.9)
        case 50...125:
            return Color(hue: 340.0/360.0, saturation: 0.8, brightness: 0.9)
        case 25...50:
            return Color(hue: 350.0/360.0, saturation: 0.8, brightness: 0.9)
        case 0...25:
            return Color(hue: 360.0/360.0, saturation: 0.8, brightness: 0.9)
        default:
            return Color(hue: 240.0/360.0, saturation: 0.8, brightness: 0.9)
        }
    }
    
    // User interface
    var body: some View {
        if questionIsActive {
            
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
                .grayscale(currentTarget.completed ? 1.0 : 0.0)
                
                VStack {
                    
                    VStack {
                        
                        HStack {
                            Text("Location manager: \(positionViewModel.location?.description ?? "No Location Provided!")")
                                .foregroundStyle(.primary)
                                .padding(.vertical)
                                .padding(.top, 75)
                            
                            Spacer()
                        }
                        
                        
                        Text("\(currentTarget.question)")
                            .foregroundStyle(.primary)
                        
                        VStack {
                            Text("Distance to target")
                                .bold()
                            Text(distanceToTargetDescription)
                                .font(.largeTitle)
                                .bold()
                                .foregroundStyle(distanceToTargetColor)
                        }
                        .padding(.vertical)
                        
                        Button {
                            positionViewModel.shouldShowQuizSheet = true
                        } label: {
                            Text("Fake arrival at location")
                                .foregroundStyle(.primaryInverted)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.primary)
                        .disabled(currentTarget.completed)
                        
                    }
                    .padding()
                    .background {
                        Rectangle()
                            .foregroundStyle(.primaryInverted)
                    }
                    .edgesIgnoringSafeArea(.all)
                    
                    Spacer()
                }
                
                
            }
            .task {
                try? await positionViewModel.requestUserAuthorization()
                await positionViewModel.monitor(
                    target: currentTarget
                )
                try? await positionViewModel.startCurrentLocationUpdates()
            }
            // Show a sheet when we enter the desired region
            .sheet(isPresented: $positionViewModel.shouldShowQuizSheet) {
                
                VStack {
                    
                    Text("You reached the target!")
                    
                    TextField("What is the answer to the question?", text: $currentAnswer)
                    
                    Button {
                        currentAnswer = currentTarget.answer
                    } label: {
                        Text("Fake correct answer")
                            .foregroundStyle(.primaryInverted)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.primary)
                    .disabled(currentTarget.completed)
                    
                    Button {
                        if currentAnswer == currentTarget.answer {
                            
                            // Mark current target as completed
                            withAnimation(Animation.easeIn(duration: 1.0)) {
                                currentTarget.completed = true
                            }
                        }
                    } label: {
                        Text("Submit")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(currentTarget.completed)
                    
                    if currentTarget.completed {
                        Image(systemName: "checkmark.seal.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                    
                }
                .presentationDetents([.medium, .fraction(0.25)])
                .presentationDragIndicator(.hidden)
            }
            
            
        } else {
            VStack {
                Text(currentTarget.question)
                
                Button {
                    questionIsActive = true
                } label: {
                    Text("Begin")
                }
                .buttonStyle(.borderedProminent)
                
            }
            .padding()
            
        }
        
    }
}

#Preview {
    PositionView(currentTarget: .constant(TargetsViewModel().targets.last!))
}
