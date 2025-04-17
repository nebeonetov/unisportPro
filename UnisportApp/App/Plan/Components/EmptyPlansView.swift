//
//  EmptyPlansView.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//

import SwiftUI

//MARK: - Empty Plans View Subview
struct EmptyPlansView: View {
    let backgroundColor: Color
    let accentColor: Color
    let action: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.run.square.stack") // Or another suitable icon
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("No Active Training Plan")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            Text("Create a personalized training plan for your next competition.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            
            Button {
                action()
            } label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Start Training Plan")
                }
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(accentColor)
                .cornerRadius(12)
                .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40) // Make button slightly narrower than full width
        }
        .padding(30)
        .background(backgroundColor)
        .cornerRadius(15)
    }
}
