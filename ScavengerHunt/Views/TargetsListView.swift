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
            List(targetsViewModel.targets) { currentTarget in
                NavigationLink {
                    Text(currentTarget.question)
                        .padding()
                } label: {
                    TargetsListItemView(target: currentTarget)
                }
            }
            .navigationTitle("Scavenger Hunt!")
        }
    }
}

#Preview {
    TargetsListView()
}
