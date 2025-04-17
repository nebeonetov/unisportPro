//
//  SubmissionStatusOverlayView.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//


import SwiftUI

enum SubmissionState: Equatable {
    case idle
    case submitting
    case success
    case error(String) // Optional: Add error state
}

struct SubmissionStatusOverlayView: View {
    @Binding var submissionState: SubmissionState

    //MARK: - Colors
    private let overlayBackground = Color.black.opacity(0.7)
    private let contentBackground = Color(red: 50/255, green: 50/255, blue: 50/255)
    private let accentColor = Color(red: 0.22, green: 0.85, blue: 0.32) // #38d951

    var body: some View {
        ZStack {
            // Dimmed background
            overlayBackground.ignoresSafeArea()

            // Content Box
            VStack(spacing: 20) {
                switch submissionState {
                case .submitting:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: accentColor))
                        .scaleEffect(1.5) // Make spinner larger
                    Text("Submitting...")
                        .font(.headline)
                        .foregroundColor(.white)
                case .success:
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(accentColor)
                    Text("Motivation sent!")
                        .font(.headline)
                        .foregroundColor(.white)
                // Optional Error State
                case .error(let message):
                     Image(systemName: "xmark.octagon.fill")
                         .resizable()
                         .scaledToFit()
                         .frame(width: 50, height: 50)
                         .foregroundColor(.red)
                     Text("Error")
                         .font(.headline)
                         .foregroundColor(.white)
                     Text(message)
                         .font(.caption)
                         .foregroundColor(.gray)
                         .multilineTextAlignment(.center)
                case .idle:
                    EmptyView() // Should not be shown in idle state normally
                }
            }
            .padding(40)
            .background(contentBackground)
            .cornerRadius(20)
            .shadow(radius: 10)
            .transition(.scale.combined(with: .opacity)) // Add transition
        }
         .animation(.easeInOut, value: submissionState) // Animate changes
    }
}
