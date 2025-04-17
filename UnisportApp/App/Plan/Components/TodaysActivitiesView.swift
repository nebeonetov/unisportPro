//
//  TodaysActivitiesView.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//

import SwiftUI

//MARK: - Today's Activities View Subview
struct TodaysActivitiesView: View {
    let activities: [DayPlan] // Pass filtered activities
    let backgroundColor: Color
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading) {
            Text("Today's Activities")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 5)

            if activities.isEmpty {
                Text("No activities planned for today.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(backgroundColor)
                    .cornerRadius(10)
            } else {
                VStack(spacing: 10) {
                     // Using ForEach directly with Realm's list or a converted array
                    ForEach(activities, id: \.id) { activity in
                        HStack {
                            Image(systemName: "figure.run") // Example icon
                                .foregroundColor(accentColor)
                                .frame(width: 30)

                            VStack(alignment: .leading) {
                                Text(activity.taskDescription.isEmpty ? "Unnamed Task" : activity.taskDescription)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                // Add more details if needed, e.g., time
                            }

                            Spacer()

                           
                        }
                        .padding()
                        .background(backgroundColor)
                        .cornerRadius(10)
                         // Add tap gesture for navigation if needed
                         // .onTapGesture { navigateToActivityDetail(activity) }
                    }
                }
            }
        }
    }
}
