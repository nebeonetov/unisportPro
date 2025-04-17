//
//  ClassDynamicsView.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//


import SwiftUI


struct ClassDynamicsView: View {
    let dynamicsData: [MonthlyDynamicsData]
    let hasWorkouts: Bool // Keep this flag to show placeholder if desired
    let backgroundColor: Color
    let accentColor: Color

    private let maxBarHeight: CGFloat = 100

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // ---> CHANGE: Update title text <---
            Text("Class Dynamics (Current & Next 5 Months)")
                .font(.headline)
                .foregroundColor(.white)

            HStack(alignment: .bottom, spacing: 15) {
                // Use hasWorkouts OR check if dynamicsData is empty to show placeholder
                if hasWorkouts { // Changed condition slightly
                    ForEach(dynamicsData) { monthData in
                        VStack(spacing: 5) {
                            Spacer()
                            
                            RoundedRectangle(cornerRadius: 5)
                                .fill(accentColor)
                                .frame(height: maxBarHeight * CGFloat(monthData.percentage))
                                // Add minimum height if you want empty months to show a tiny sliver
                                .frame(minHeight: 1)

                            Text(monthData.monthAbbreviation)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.bottom, 20)
                        }
                        .frame(maxWidth: .infinity)
                    }
                } else {
                    // Placeholder View (If dynamicsData is empty)
                    // You might want to adjust the placeholder text now
                    Text("Log workouts to see your dynamics.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                }
            }
            .frame(height: maxBarHeight + 30)
             // Keep animation if you like the transition
            .animation(.easeInOut, value: dynamicsData.map { $0.id }) // Animate based on data changes

        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(15)
    }
}


