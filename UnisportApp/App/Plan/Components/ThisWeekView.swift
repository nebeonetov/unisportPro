//
//  ThisWeekView.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//

import SwiftUI

//MARK: - This Week View Subview
struct ThisWeekView: View {
    let accentColor: Color
    let secondaryTextColor: Color
    // TODO: Get real completion data from ViewModel
    @State private var weekCompletion: [Bool] = [false, false, false, false, false, false, false] // Mock data

    private let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    // Determine current day index (0=Mon, 6=Sun) - Adjust based on your calendar settings
    private var currentDayIndex: Int {
         // Sunday = 1, Saturday = 7. Adjust to Mon = 0.
        let weekDay = Calendar.current.component(.weekday, from: Date())
        return (weekDay + 5) % 7
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("This Week")
                .font(.headline)
                .foregroundColor(.white)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(daysOfWeek.indices, id: \.self) { index in
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(weekCompletion[index] ? accentColor : Color.gray.opacity(0.3))
                                    .frame(width: 40, height: 40)

                                if weekCompletion[index] {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.black)
                                        .font(.system(size: 16, weight: .bold))
                                }

                                // Highlight current day
                                if index == currentDayIndex {
                                    Circle()
                                         .stroke(accentColor, lineWidth: 2.5)
                                         .frame(width: 45, height: 45) // Slightly larger circle for border
                                }
                            }
                            Text(daysOfWeek[index])
                                .font(.caption)
                                .foregroundColor(index == currentDayIndex ? .white : secondaryTextColor)
                        }
                        // Add tap gesture if needed to mark completion
                        // .onTapGesture { viewModel.toggleDayCompletion(for: dateForDayIndex(index)) }
                    }
                }
                 .padding(.horizontal, 5) // Padding inside scrollview if needed
            }
        }
    }

    // Helper to get the date for a given day index in the current week (optional)
    /*
    private func dateForDayIndex(_ index: Int) -> Date {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else { return Date() }
        return calendar.date(byAdding: .day, value: index, to: startOfWeek) ?? Date() // Adjust logic based on how week starts
    }
    */
}
