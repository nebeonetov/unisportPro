//
//  UpcomingPlansView.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//

import SwiftUI
import RealmSwift // Import RealmSwift if using @ObservedRealmObject

struct UpcomingPlansView: View {
    // Receive the active plan (optional) from the ViewModel
    let activePlan: TrainingPlan? // Can be nil if no active plan

    let backgroundColor: Color
    let secondaryTextColor: Color
    let accentColor: Color

    // Placeholder text if no active plan
    private let placeholderText = "No active training plan. Go to the 'Plans' tab to create one!"

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Upcoming Plan") // Changed title slightly
                .font(.headline)
                .foregroundColor(.white)

            if let plan = activePlan, !plan.isInvalidated { // Check if plan exists and is valid
                // Use ActivePlanCard directly if it suits the design,
                // or create a specific simplified card for the Tracker view.
                // Let's use ActivePlanCard for consistency for now.
                ActivePlanCard(
                    plan: plan,
                    backgroundColor: backgroundColor, // Pass appropriate background
                    accentColor: accentColor
                )
                // Optional: Add navigation link to Plans tab/view
                // .onTapGesture { navigateToPlansTab() }

            } else {
                // Placeholder View
                Text(placeholderText)
                    .font(.subheadline)
                    .foregroundColor(secondaryTextColor)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(backgroundColor) // Use card background for placeholder too
                    .cornerRadius(15)
            }
        }
         // Remove padding/background/cornerRadius from the VStack itself
         // if the inner content (card or placeholder) already has it.
         // .padding()
         // .background(backgroundColor) // Background applied to inner elements
         // .cornerRadius(15)
    }
}
