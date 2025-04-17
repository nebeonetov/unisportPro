//
//  ActivityBoardView.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//
//MARK: - Activity Board View Block (Corrected for "Week Ahead")
// ActivityBoardView.swift

import SwiftUI

struct ActivityBoardView: View {
    @ObservedObject var viewModel: TrackerViewModel
    let backgroundColor: Color
    let accentColor: Color

    @State private var isExpanded: Bool = false
    private let neutralSquareColor = Color.gray.opacity(0.3)
    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 5), count: 7)

    private var dateRange: [Date] {
        calculateDateRange()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Activity Board")
                    .font(.headline).foregroundColor(.white)
                Spacer()
                Button {
                    withAnimation(.easeInOut) { isExpanded.toggle() }
                } label: {
                    Image(systemName: isExpanded ? "calendar.badge.minus" : "calendar")
                        .foregroundColor(.white).padding(8).background(Color.white.opacity(0.1)).clipShape(Circle())
                }
            }

            LazyVGrid(columns: columns, spacing: 5) {
                // dateRange contains normalized startOfDay dates
                ForEach(dateRange, id: \.self) { date in
                    // Check existence using the normalized date from the range
                    let workoutExists = viewModel.workoutExists(for: date)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(workoutExists ? accentColor : neutralSquareColor)
                        .aspectRatio(1.0, contentMode: .fit)
                        .onTapGesture {
                            // Pass the normalized date
                            viewModel.handleGridSquareTap(for: date)
                        }
                }
            }
            .frame(maxWidth: .infinity)
            .id(isExpanded) // Force redraw on mode change

            Button {
                viewModel.handleMarkWorkoutTap()
            } label: {
                Label(viewModel.todaysWorkout != nil ? "Workout Logged Today" : "Mark Workout",
                      systemImage: viewModel.todaysWorkout != nil ? "checkmark.circle.fill" : "plus")
                    .font(.headline).fontWeight(.semibold)
                    .foregroundColor(viewModel.todaysWorkout != nil ? .white.opacity(0.7) : .black)
                    .frame(maxWidth: .infinity).padding()
                    .background(viewModel.todaysWorkout != nil ? Color.gray.opacity(0.5) : accentColor)
                    .cornerRadius(12)
            }
            .disabled(viewModel.todaysWorkout != nil)
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(15)
    }

    //MARK: - Helper Functions (Corrected for "Week Ahead")
    private func calculateDateRange() -> [Date] {
        let calendar = Calendar.current
        let todayStartOfDay = calendar.startOfDay(for: Date()) // Normalize today

        if isExpanded {
            // Month View Logic: Generate startOfDay for each day in the month
            guard let monthInterval = calendar.dateInterval(of: .month, for: todayStartOfDay),
                  let daysInMonth = calendar.range(of: .day, in: .month, for: todayStartOfDay)?.count else {
                return []
            }
            let firstDayOfMonthStart = calendar.startOfDay(for: monthInterval.start)
            return (0..<daysInMonth).compactMap { dayOffset in
                calendar.date(byAdding: .day, value: dayOffset, to: firstDayOfMonthStart)
            }
        } else {
            // NEW Week View Logic: Today and the next 6 days [Today -> Future]
            return (0..<7).compactMap { dayOffset in
                calendar.date(byAdding: .day, value: dayOffset, to: todayStartOfDay)
            }
            // First square is today, second is tomorrow, etc.
        }
    }
}
////MARK: - Previews (Example container for context)
//struct ActivityBoardView_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack {
//            Color(red: 34/255, green: 34/255, blue: 34/255).ignoresSafeArea()
//             ActivityBoardView(
//                backgroundColor: Color.black.opacity(0.25),
//                accentColor: Color(red: 0.22, green: 0.85, blue: 0.32)
//             )
//             .padding()
//        }
//
//    }
//}
