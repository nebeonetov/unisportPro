//
//  TerminatePlanButton.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//

import SwiftUI


//MARK: - Terminate Plan Button Subview
struct TerminatePlanButton: View {
    let action: () -> Void
    let accentColor: Color

    var body: some View {
        Button(action: action) {
            Text("Terminate Plan")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.red) // Make it red for termination
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.2)) // Reddish background
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.red, lineWidth: 1) // Red border
                )
        }
        .padding(.vertical) // Add some vertical space around it
    }
}
