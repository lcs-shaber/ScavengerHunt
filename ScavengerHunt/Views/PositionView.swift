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

                VStack {
                    
                    VStack {
                        
                        HStack {
                            Text("Location manager: \(positionViewModel.location?.description ?? "No Location Provided!")")
                                .padding(.vertical)
                                .padding(.top, 75)
                            
                            Spacer()
                        }

                        
                        HStack {
                            Text("\(currentTarget.question)")
                            
                            Spacer()
                        }
                        
                        HStack {
                            Button {
                                positionViewModel.shouldShowQuizSheet = true
                            } label: {
                                Text("Fake arrival at location")
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(.top)

                            Spacer()
                        }
                        
                    }
                    .padding()
                    .foregroundStyle(.white)
                    .background(Rectangle())
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
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    
                    Button {
                        if currentAnswer == currentTarget.answer {
                            
                            // Mark current target as completed
                            currentTarget.completed = true
                        }
                    } label: {
                        Text("Submit")
                    }
                    .buttonStyle(.borderedProminent)
                    
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
