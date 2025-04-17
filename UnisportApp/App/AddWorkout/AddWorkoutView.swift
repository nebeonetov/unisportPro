//
//  AddWorkoutView.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//

import SwiftUI

//MARK: - Data Structures
enum WorkoutMood: String, CaseIterable, Identifiable {
    case amazing = "Amazing"
    case good = "Good"
    case okay = "Okay"
    case bad = "Bad"
    case terrible = "Terrible"

    var id: String { self.rawValue }

    var iconName: String {
        switch self {
        case .amazing: return "happyIcon"
        case .good: return "goodIcon"
        case .okay: return "normalIcon"
        case .bad: return "sadIcon"
        case .terrible: return "badIcon"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .amazing: return Color(red: 255/255, green: 215/255, blue: 0/255).opacity(0.4)
        case .good: return Color(red: 60/255, green: 179/255, blue: 113/255).opacity(0.5)
        case .okay: return Color(red: 100/255, green: 149/255, blue: 237/255).opacity(0.5)
        case .bad: return Color(red: 255/255, green: 165/255, blue: 0/255).opacity(0.5)
        case .terrible: return Color(red: 220/255, green: 20/255, blue: 60/255).opacity(0.5)
        }
    }

    var iconColor: Color {
         switch self {
         case .amazing: return Color(red: 255/255, green: 215/255, blue: 0/255)
        case .good: return Color(red: 60/255, green: 179/255, blue: 113/255)
        case .okay: return Color(red: 100/255, green: 149/255, blue: 237/255)
        case .bad: return Color(red: 255/255, green: 165/255, blue: 0/255)
        case .terrible: return Color(red: 220/255, green: 20/255, blue: 60/255)
        }
    }
}

//MARK: - Add Workout View Block (No major changes needed, just using callbacks)
// AddWorkoutView.swift

import SwiftUI

// Assuming WorkoutMood enum exists as defined previously

struct AddWorkoutView: View {

    @State private var workoutDescription: String = ""
    @State private var selectedMood: WorkoutMood? = nil
    @State private var experienceNotes: String = ""

    var onDismiss: () -> Void // Closure to dismiss the view
    var onSave: (String, WorkoutMood?, String) -> Void // Closure to save data

    //MARK: - Colors
    private let viewBackgroundColor = Color(red: 45/255, green: 45/255, blue: 45/255).opacity(0.95) // Slight transparency
    private let itemBackgroundColor = Color.black.opacity(0.4)
    private let accentColor = Color(red: 0.22, green: 0.85, blue: 0.32)
    private let secondaryTextColor = Color.gray
    private let placeholderTextColor = Color.gray

     var experienceNotesPlaceholder: String = "Share your experience..."
     var showExperiencePlaceholder: Bool { experienceNotes.isEmpty }

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("Add Workout")
                    .font(.title2).fontWeight(.bold).foregroundColor(.white)
                Spacer()
                Button(action: onDismiss) { // Use dismiss closure
                    Image(systemName: "xmark").font(.title3).foregroundColor(.white.opacity(0.7))
                }
            }
            .padding(.bottom, 10)

            // Workout Description Input
            VStack(alignment: .leading, spacing: 8) {
                Text("What did you do?").font(.headline).foregroundColor(.white.opacity(0.9))
                TextField("e.g., Running 5km", text: $workoutDescription)
                    .foregroundColor(.white).padding(12).background(itemBackgroundColor).cornerRadius(10).tint(accentColor)
            }

            // Mood Selection
            VStack(alignment: .leading, spacing: 10) {
                Text("How was it?").font(.headline).foregroundColor(.white.opacity(0.9))
                HStack(spacing: 10) {
                    ForEach(WorkoutMood.allCases) { mood in
                        Button { selectedMood = (selectedMood == mood) ? nil : mood } label: {
                            VStack { Image(mood.iconName).resizable().frame(width: 30, height: 30).font(.title).foregroundColor(mood.iconColor) }
                                .frame(maxWidth: .infinity).frame(height: 55).background(itemBackgroundColor).cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(selectedMood == mood ? accentColor : Color.clear, lineWidth: 2.5))
                        }
                    }
                }
            }

            // Training Experience Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Training experience (optional)").font(.headline).foregroundColor(.white.opacity(0.9))
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $experienceNotes)
                        .scrollContentBackground(.hidden).foregroundColor(.white).frame(height: 100).padding(8)
                        .background(itemBackgroundColor).cornerRadius(10).tint(accentColor)
                    if showExperiencePlaceholder {
                        Text(experienceNotesPlaceholder)
                            .foregroundColor(placeholderTextColor).padding(.horizontal, 13).padding(.vertical, 16).allowsHitTesting(false)
                    }
                }
            }

            // Save Button
            Button {
                // Dismiss keyboard first if needed
                 UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                // Call save closure from ViewModel
                 onSave(workoutDescription, selectedMood, experienceNotes)
            } label: {
                Text("Save Workout").font(.headline).fontWeight(.semibold).foregroundColor(.black)
                    .frame(maxWidth: .infinity).padding().background(accentColor).cornerRadius(12)
            }
            .padding(.top, 10)
            .disabled(workoutDescription.isEmpty)
            .opacity(workoutDescription.isEmpty ? 0.6 : 1.0)

        }
        .padding(25)
        .background(viewBackgroundColor) // Use slightly transparent bg
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.4) ,radius: 15)
    }
}


//MARK: - Previews
struct AddWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
         // Also preview the view itself directly
         AddWorkoutView(onDismiss: {}, onSave: {_,_,_ in})
            .padding(30) // Add padding for standalone preview
            .background(Color.black)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)

    }
}
