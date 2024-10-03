//
//  TargetsListItemView.swift
//  ScavengerHunt
//
//  Created by Russell Gordon on 2024-10-03.
//

import SwiftUI

struct TargetsListItemView: View {
    
    @Binding var target: TargetRegion
    
    var body: some View {
        Text(target.question)
    }
}

#Preview {
    TargetsListItemView(
        target: .constant(TargetsViewModel().targets.last!)
    )
    .padding()
}
