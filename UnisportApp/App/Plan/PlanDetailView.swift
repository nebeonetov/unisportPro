//
//  PlanDetailView.swift
//  UnisportApp
//
//  Created by D K on 16.04.2025.
//

//MARK: - Plan Detail View Block (New)
// PlanDetailView.swift

import SwiftUI
import RealmSwift

struct PlanDetailView: View {
    // Observe the specific plan passed to this view
    @ObservedRealmObject var plan: TrainingPlan

    //MARK: - Colors
    private let backgroundColor = Color(red: 34/255, green: 34/255, blue: 34/255)
    private let cardBackgroundColor = Color.black.opacity(0.25)
    private let accentColor = Color(red: 0.22, green: 0.85, blue: 0.32) // Or maybe gray/white for completed state?
    private let secondaryTextColor = Color.gray
    private let completedTextColor = Color.gray // Color for completed tasks

    var body: some View {
        List {
            Section {
                Text(plan.title)
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .listRowBackground(cardBackgroundColor)

            } header: {
                Text("Plan Name")
                     .foregroundColor(secondaryTextColor)
                     .padding(.top)
            }
            
            // Section for Plan Summary (Optional, could just be title)
             Section {
                 VStack(alignment: .leading, spacing: 5) {
                      Text("Status: \(plan.status.rawValue.capitalized)")
                           .font(.subheadline)
                           .foregroundColor(statusColor(plan.status))
                      if let endDate = plan.endDate {
                           Text("Original End Date: \(endDate, style: .date)")
                                .font(.subheadline)
                                .foregroundColor(secondaryTextColor)
                      }
                      Text("Total Days: \(plan.days.count)")
                           .font(.subheadline)
                           .foregroundColor(secondaryTextColor)
                      Text(String(format: "Completion: %.0f%%", plan.completionPercentage))
                           .font(.subheadline)
                           .foregroundColor(secondaryTextColor)
                 }
                  .listRowBackground(cardBackgroundColor)
                  .padding(.vertical, 5)

             } header: {
                 Text("Plan Summary")
                      .foregroundColor(secondaryTextColor)
                      .padding(.top)
             }

            // Section for Daily Steps
            Section {
                // Sort days chronologically for display
                ForEach(plan.days.sorted(by: { $0.date < $1.date })) { day in
                    PlanDayDetailRow(
                        day: day,
                        dayNumber: (plan.days.sorted(by: { $0.date < $1.date }).firstIndex(where: { $0.id == day.id }) ?? 0) + 1,
                        accentColor: accentColor, // Could be dynamic based on completion?
                        secondaryTextColor: secondaryTextColor,
                        completedTextColor: completedTextColor,
                        cardBackgroundColor: cardBackgroundColor
                    )
                    .listRowInsets(EdgeInsets()) // Remove default padding
                    .listRowSeparator(.hidden) // Hide default separators
                     .padding(.vertical, 8)
                     .padding(.horizontal, 10)
                     .listRowBackground(backgroundColor) // Match background
                     .listRowBackground(Color.clear)
                }
            } header: {
                Text("Daily Activities")
                    .foregroundColor(secondaryTextColor)
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(backgroundColor.ignoresSafeArea()) // Set background for the List area
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
         // Handle potential deletion while viewing
         .opacity(plan.isInvalidated ? 0 : 1)
         .animation(.default, value: plan.isInvalidated)
    }

    // Helper to determine status color
    private func statusColor(_ status: PlanStatus) -> Color {
        switch status {
        case .active: return accentColor // Should not happen here ideally
        case .completed: return .green
        case .terminated: return .orange
        }
    }
}

//MARK: - Plan Day Detail Row Subview (Read-only version)
struct PlanDayDetailRow: View {
    @ObservedRealmObject var day: DayPlan // Observe the day object
    let dayNumber: Int
    let accentColor: Color
    let secondaryTextColor: Color
    let completedTextColor: Color
    let cardBackgroundColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center) {
                Text("\(dayNumber)")
                    .font(.headline)
                    .foregroundColor(day.isCompleted ? .white.opacity(0.6) : .black) // Dim number if completed
                    .frame(width: 24, height: 24)
                    .background(day.isCompleted ? Color.gray.opacity(0.6) : accentColor) // Gray background if completed
                    .clipShape(Circle())
                    // Apply strikethrough effect to circle background maybe?

                Text(day.date, style: .date)
                    .font(.headline)
                    .foregroundColor(day.isCompleted ? completedTextColor : .white) // Change text color
                    .strikethrough(day.isCompleted, color: completedTextColor) // Apply strikethrough

                Spacer()

                 // Show checkmark if completed
                 if day.isCompleted {
                      Image(systemName: "checkmark.circle.fill")
                           .foregroundColor(.green) // Use explicit green for checkmark
                 } else {
                     // Optionally show an empty circle or nothing
                     // Image(systemName: "circle")
                     //     .foregroundColor(secondaryTextColor)
                 }
            }

            // Task Description
            Text(day.taskDescription.isEmpty ? "No task specified" : day.taskDescription)
                 .font(.subheadline)
                 .foregroundColor(day.isCompleted ? completedTextColor : .white.opacity(0.9)) // Change text color
                 .strikethrough(day.isCompleted, color: completedTextColor) // Apply strikethrough
                 .frame(maxWidth: .infinity, alignment: .leading) // Ensure it takes full width
                 .padding(.leading, 34) // Indent text to align under date

        }
        .padding()
        .background(cardBackgroundColor) // Background for the whole row card
        .cornerRadius(15)
        .opacity(day.isInvalidated ? 0 : 1) // Handle potential deletion
    }
}
