//
//  PreviousPlansView.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//

import SwiftUI

//MARK: - Previous Plans View Subview
struct PreviousPlansView: View {
    let plans: [TrainingPlan] // Pass filtered plans
    let backgroundColor: Color
    let secondaryTextColor: Color

    var body: some View {
        VStack(alignment: .leading) {
            if !plans.isEmpty {
                Text("Previous Plans")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)

                VStack(spacing: 10) {
                    ForEach(plans) { plan in
                        HStack {
                            Image(systemName: plan.status == .terminated ? "figure.walk.circle" : "flag.checkered.circle") // Example icons
                                .foregroundColor(secondaryTextColor)
                                .frame(width: 30)

                            VStack(alignment: .leading) {
                                Text(plan.title)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                Text(plan.status == .terminated ? "Terminated \(plan.createdAt, style: .date)" : "Completed \(plan.createdAt, style: .date)") // Adjust date format
                                    .font(.caption)
                                    .foregroundColor(secondaryTextColor)
                            }
                            Spacer()
                             Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(backgroundColor)
                        .cornerRadius(10)
                        // Add tap gesture if needed
                    }
                }
            }
        }
    }
}
