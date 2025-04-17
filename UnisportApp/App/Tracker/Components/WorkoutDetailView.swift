//
//  WorkoutDetailView.swift
//  UnisportApp
//
//  Created by D K on 16.04.2025.
//

import SwiftUI

struct WorkoutDetailView: View {
    let workout: WorkoutEntry
    var onDismiss: () -> Void

    //MARK: - Colors
    private let viewBackgroundColor = Color(red: 45/255, green: 45/255, blue: 45/255).opacity(0.95)
    private let itemBackgroundColor = Color.black.opacity(0.25)
    private let accentColor = Color(red: 0.22, green: 0.85, blue: 0.32)
    private let secondaryTextColor = Color.gray

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            //MARK: - Header
            HStack {
                Text("Workout Details")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.7))
                }
            }

            //MARK: - Date
            DetailRow(label: "Date", value: workout.date, formatter: .mediumDate)

            //MARK: - Description
            DetailRow(label: "Workout", value: workout.workoutDescription)

            //MARK: - Mood
            if let mood = workout.mood {
                 HStack(alignment: .firstTextBaseline) {
                    Text("Mood:")
                         .font(.headline)
                         .foregroundColor(secondaryTextColor)
                         .frame(width: 80, alignment: .leading) // Align labels
                    Image(mood.iconName)
                         .resizable()
                         .frame(width: 10, height: 10)
                     Text(mood.rawValue)
                         .font(.subheadline)
                         .foregroundColor(.white)
                    Spacer()
                 }
            } else {
                DetailRow(label: "Mood", value: "Not specified")
            }

            //MARK: - Notes
            if let notes = workout.notes, !notes.isEmpty {
                DetailRow(label: "Notes", value: notes)
            } else {
                DetailRow(label: "Notes", value: "No notes added")
            }

            Spacer() // Pushes content to top
        }
        .padding(25)
        .background(viewBackgroundColor)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.4), radius: 15)
    }
}

//MARK: - Detail Row Helper
struct DetailRow: View {
    let label: String
    let value: String
    var alignment: HorizontalAlignment = .leading

    init(label: String, value: String, alignment: HorizontalAlignment = .leading) {
        self.label = label
        self.value = value
        self.alignment = alignment
    }

    init(label: String, value: Date, formatter: DateFormatter = .mediumDate, alignment: HorizontalAlignment = .leading) {
        self.label = label
        self.value = value.formatted(formatter)
        self.alignment = alignment
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("\(label):")
                .font(.headline)
                .foregroundColor(.gray)
                .frame(width: 80, alignment: .leading) // Align labels

            Text(value)
                .font(.subheadline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading) // Allow text wrapping

        }
    }
}

//MARK: - Date Formatter Extension
extension Date {
    func formatted(_ style: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        return formatter.string(from: self)
    }
    func formatted(_ formatter: DateFormatter) -> String {
         return formatter.string(from: self)
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()

    static let mediumDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}
