//
//  ActivePlanCard.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//

import SwiftUI
import RealmSwift

//MARK: - Active Plan Card Subview
struct ActivePlanCard: View {
     // Используем @ObservedRealmObject для автоматического обновления UI при изменении объекта
    @ObservedRealmObject var plan: TrainingPlan

    let backgroundColor: Color
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(plan.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                Text(String(format: "%.0f%% done", plan.completionPercentage))
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
            }

            if let daysLeft = plan.daysLeft {
                Text("\(daysLeft) days left")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(accentColor)
            } else {
                Text("End date not set")
                     .font(.subheadline)
                     .fontWeight(.medium)
                     .foregroundColor(.gray)
            }


            ProgressView(value: plan.completionPercentage, total: 100)
                .tint(accentColor)
                .scaleEffect(x: 1, y: 1.5, anchor: .center) // Make the bar thicker
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(15)
    }
}
