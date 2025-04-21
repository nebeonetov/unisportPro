//
//  PersonalizationPageView.swift
//  UnisportApp
//
//  Created by D K on 21.04.2025.
//


import SwiftUI

//MARK: - Personalization Page (New Page before Ready To Start)
struct PersonalizationPageView: View {
    let page: OnboardingPage // We might use title/desc later
    let accentColor: Color

    // Data Options
    let sports = ["Running", "Cycling", "Swimming", "Gym", "Yoga", "Football", "Basketball", "Tennis", "Hiking", "CrossFit", "Other"]
    let levels = ["Beginner", "Intermediate", "Advanced"] // Renamed for clarity
    let goals = ["Improve Performance", "Weight Loss", "Improve Well-being", "Increase Strength", "Boost Motivation", "Other"]
    let sources = ["Social Media", "App Store", "Recommendation", "Advertisement"]

    // State Variables to store user selections
    @State private var selectedSport: String? = nil // Use Optional for initial state
    @State private var customSport: String = ""
    @State private var selectedLevel: String = "Beginner"
    @State private var selectedGoals: Set<String> = [] // Set for multiple selections
    @State private var selectedSource: String? = nil // Use Optional for initial state

    // Animation State
    @State private var appear = false

    // Focus state for the custom sport text field
    @FocusState private var isCustomSportFieldFocused: Bool

    var body: some View {
        ScrollView { // Use ScrollView to prevent overflow
            VStack(spacing: 25) {
                // --- Title ---
                Text(page.title) // Use title from OnboardingData
                    .font(.title2).fontWeight(.bold).foregroundColor(.white)
                    .padding(.top, 30) // Add some top padding inside scrollview
                    .opacity(appear ? 1 : 0)
                    .offset(y: appear ? 0 : 10)

                // --- Sport Selection ---
                VStack(alignment: .leading, spacing: 10) {
                    Text("Favorite Sport:")
                        .font(.headline).foregroundColor(.white.opacity(0.8))

                    // Use buttons for better customization and handling "Other"
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 10)], spacing: 10) {
                        ForEach(sports.filter { $0 != "Other" }, id: \.self) { sport in
                            SelectableButton(title: sport, isSelected: selectedSport == sport, accentColor: accentColor) {
                                selectedSport = sport
                                isCustomSportFieldFocused = false // Hide keyboard if open
                            }
                        }
                        // "Other" Button
                        SelectableButton(title: "Other", isSelected: selectedSport == "Other", accentColor: accentColor) {
                            selectedSport = "Other"
                             DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Allow UI to update
                                 isCustomSportFieldFocused = true // Focus the text field
                            }
                        }
                    }

                    // Custom Sport Text Field (appears when "Other" is selected)
                    // Внутри VStack(alignment: .leading, spacing: 10) для спорта
                    if selectedSport == "Other" {
                        TextField("Enter your sport", text: $customSport)
                            .focused($isCustomSportFieldFocused)
                            .padding(10)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .transition(.opacity.combined(with: .scale(scale: 0.9)))
                            .padding(.top, 5)
                            // --- ДОБАВЬ ЭТОТ МОДИФИКАТОР ---
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer() // Кнопка справа
                                    Button("Done") {
                                        isCustomSportFieldFocused = false // Скрыть клавиатуру
                                    }
                                    .tint(accentColor) // Опционально: окрасить кнопку
                                }
                            }
                            // --- КОНЕЦ ДОБАВЛЕНИЯ ---
                    }
                }
                .padding(.horizontal, 30)
                .opacity(appear ? 1 : 0)
                .offset(y: appear ? 0 : 10)
                .animation(.easeInOut.delay(0.1), value: appear)

                // --- Level Selection ---
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your Fitness Level:")
                        .font(.headline).foregroundColor(.white.opacity(0.8))
                    Picker("Level", selection: $selectedLevel) {
                        ForEach(levels, id: \.self) { level in
                            Text(level).tag(level as String?) // Tag as Optional String
                        }
                    }
                    .pickerStyle(.segmented)
                    .tint(accentColor)
                }
                .padding(.horizontal, 30)
                .opacity(appear ? 1 : 0)
                .offset(y: appear ? 0 : 10)
                .animation(.easeInOut.delay(0.2), value: appear)


                // --- Goal Selection (Multiple) ---
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your Goals:")
                        .font(.headline).foregroundColor(.white.opacity(0.8))
                    // Use buttons for multiple selection
                     LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 10)], spacing: 10) {
                         ForEach(goals, id: \.self) { goal in
                             SelectableButton(title: goal, isSelected: selectedGoals.contains(goal), accentColor: accentColor) {
                                 if selectedGoals.contains(goal) {
                                     selectedGoals.remove(goal)
                                 } else {
                                     selectedGoals.insert(goal)
                                 }
                             }
                        }
                    }
                }
                .padding(.horizontal, 30)
                .opacity(appear ? 1 : 0)
                .offset(y: appear ? 0 : 10)
                .animation(.easeInOut.delay(0.3), value: appear)

                // --- Source Selection ---
                VStack(alignment: .leading, spacing: 10) {
                    Text("How did you hear about us?")
                        .font(.headline).foregroundColor(.white.opacity(0.8))
                     // Use buttons for single selection here too for consistency
                     LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 10)], spacing: 10) {
                         ForEach(sources, id: \.self) { source in
                            SelectableButton(title: source, isSelected: selectedSource == source, accentColor: accentColor) {
                                selectedSource = source
                            }
                        }
                    }
                }
                .padding(.horizontal, 30)
                .opacity(appear ? 1 : 0)
                .offset(y: appear ? 0 : 10)
                .animation(.easeInOut.delay(0.4), value: appear)

                Spacer() // Pushes content up if screen is large
            }
            .frame(maxWidth: .infinity) // Ensure VStack takes full width
        }
        .onAppear {
            withAnimation(.interpolatingSpring(stiffness: 50, damping: 10).delay(0.2)) {
                 appear = true
            }
        }
        // Add tap gesture to dismiss keyboard when tapping outside the text field
       
        // Store collected data somewhere when user proceeds (e.g., in AppStorage or pass via ViewModel)
        // For now, we just display the screen. Data handling needs separate implementation.
    }
}

// Helper View for Selectable Buttons (to avoid repetition)
struct SelectableButton: View {
    let title: String
    let isSelected: Bool
    let accentColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption) // Slightly smaller font for buttons
                .fontWeight(.medium)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity) // Make buttons expand
                .foregroundColor(isSelected ? .black : .white.opacity(0.9))
                .background(isSelected ? accentColor : Color.gray.opacity(0.25))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? accentColor : Color.gray.opacity(0.5), lineWidth: 1)
                )
        }
    }
}

// Add a Preview Provider if needed
struct PersonalizationPageView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalizationPageView(
            page: OnboardingPage(imageName: nil, title: "Tell Us About You", description: "Personalize..."),
            accentColor: Color(red: 0.22, green: 0.85, blue: 0.32)
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 34/255, green: 34/255, blue: 34/255))
        .preferredColorScheme(.dark)
    }
}
