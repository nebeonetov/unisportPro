//
//  PlanDayRow.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//

import SwiftUI




//MARK: - Plan Day Row Subview
struct PlanDayRow: View {
    @Binding var entry: PlanDayEntry
    let dayNumber: Int
    let accentColor: Color
    let secondaryTextColor: Color
    let cardBackgroundColor: Color
    let placeholderTextColor: Color
    let updateDateAction: (Date) -> Void

    @State private var showDatePicker = false

    var taskPlaceholder: String = "What should I do on this day?"

    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .center) {
                Text("\(dayNumber)")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(width: 24, height: 24)
                    .background(accentColor)
                    .clipShape(Circle())

                 // Use Button to toggle DatePicker
                Button {
                    showDatePicker.toggle()
                } label: {
                    Text(entry.date, style: .date)
                        .font(.headline)
                        .foregroundColor(.white)
                }


                Spacer()

                Image(systemName: "line.3.horizontal") // Drag handle icon
                    .foregroundColor(secondaryTextColor)
            }


             // Show DatePicker conditionally below the date text
             if showDatePicker {
                  DatePicker(
                       "",
                       selection: $entry.date,
                       displayedComponents: [.date]
                  )
                  .datePickerStyle(.graphical) // Use graphical style for better UX
                  .labelsHidden()
                  .onChange(of: entry.date) { newDate in
                       updateDateAction(newDate) // Call the update action in ViewModel
                       // Optional: Automatically hide picker after selection
                       // showDatePicker = false
                  }
                  .padding(.horizontal, -10) // Adjust padding to align picker nicely
                  .tint(accentColor) // Color the picker elements
             }


            ZStack(alignment: .topLeading) {
                TextEditor(text: $entry.taskDescription)
                    .scrollContentBackground(.hidden) // Use this for clear background
                    .foregroundColor(.white)
                    .frame(minHeight: 60) // Ensure decent height
                    .padding(8)
                    .background(cardBackgroundColor) // Background applied here
                    .cornerRadius(10)
                    .tint(accentColor) // Set cursor/highlight color

                 if entry.taskDescription.isEmpty {
                    Text(taskPlaceholder)
                        .foregroundColor(placeholderTextColor)
                        .padding(.horizontal, 13)
                        .padding(.vertical, 16)
                        .allowsHitTesting(false) // Allow taps to go through to TextEditor
                }
            }
        }
        .padding()
        .background(cardBackgroundColor) // Background for the whole row card
        .cornerRadius(15)
    }
}
