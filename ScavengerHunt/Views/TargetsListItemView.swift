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
        Label {
            HStack {
                Text(target.question)
                    .strikethrough(target.completed)
                Spacer()
            }
        } icon: {
            Image(systemName: target.completed ? "checkmark.circle" : "circle")
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview {
    List {
        TargetsListItemView(
            target: .constant(TargetsViewModel().targets.last!)
        )
    }
}
