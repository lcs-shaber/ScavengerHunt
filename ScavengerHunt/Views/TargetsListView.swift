//
//  TargetsListView.swift
//  ScavengerHunt
//
//  Created by Russell Gordon on 2024-10-03.
//

import SwiftUI

struct TargetsListView: View {
    
    // MARK: Stored properties
    
    // Used to track progress through targets
    @State var targetsViewModel = TargetsViewModel()

    // MARK: Computed properties
    var body: some View {
        NavigationStack {
            List {
                ForEach($targetsViewModel.targets) { currentTarget in
                    if currentTarget.completed.wrappedValue == true {
                        TargetsListItemView(target: currentTarget)
                    } else {
                        NavigationLink {
                            PositionView(currentTarget: currentTarget)
                        } label: {
                            TargetsListItemView(target: currentTarget)
                        }
                    }
                }
                .listRowBackground(Color.clear)
            }
            // Add a new background color for the list
            .background {
                LinearGradient(colors: [.gradientStart, .gradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
            }
            // Hide regular list color
            .scrollContentBackground(.hidden)
            // Make the background color of the list shine through when scrolling up
            .toolbarBackground(.ultraThinMaterial)
            .navigationTitle("LCS Scavenger Hunt")
        }
    }
}

#Preview {
    TargetsListView()
}
