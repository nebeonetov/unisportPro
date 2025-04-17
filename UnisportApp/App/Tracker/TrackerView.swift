//
//  TrackerView.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//

import SwiftUI

struct TrackerView: View {
    
    @StateObject private var viewModel = TrackerViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    
    //MARK: - Colors
    private let backgroundColor = Color(red: 34/255, green: 34/255, blue: 34/255)
    private let cardBackgroundColor = Color.black.opacity(0.25)
    private let accentColor = Color(red: 0.22, green: 0.85, blue: 0.32)
    private let secondaryTextColor = Color.gray
    private let overlayBackground = Color.black.opacity(0.6) // Dimming background
    
    var body: some View {
        ZStack { // Use ZStack to layer main content and overlays
            //MARK: - Main Scrollable Content
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    // Header (Assuming it's part of a NavigationView elsewhere or static)
                    HStack {
                        Text("My Activity")
                            .font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                        Spacer()
                        (profileViewModel.avatarImage ?? Image(systemName: "person.crop.circle.fill")) // Use loaded image or placeholder
                            .resizable()
                            .aspectRatio(contentMode: .fill) // Fill circle
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                            .background( // Background for placeholder
                                Circle().fill(Color.gray.opacity(0.5))
                            )
                            .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))
                    }
                    .padding(.horizontal).padding(.top)
                    
                    // Activity Board Section (Uses the updated ActivityBoardView)
                    ActivityBoardView(
                        viewModel: viewModel,
                        backgroundColor: cardBackgroundColor,
                        accentColor: accentColor
                    )
                    .padding(.horizontal)
                    
                    //MARK: - Class Dynamics Section (Updated Call)
                    ClassDynamicsView(
                        dynamicsData: viewModel.monthlyDynamics, // Pass calculated data
                        hasWorkouts: viewModel.hasAnyWorkouts, // Pass flag
                        backgroundColor: cardBackgroundColor,
                        accentColor: accentColor
                    )
                    .padding(.horizontal)
                    
                    // Consistency Index Section
//                    ConsistencyIndexView(backgroundColor: cardBackgroundColor, secondaryTextColor: secondaryTextColor)
//                        .padding(.horizontal)
                    
                    // Featured Tips Section
                    FeaturedTipsView(backgroundColor: cardBackgroundColor, secondaryTextColor: secondaryTextColor)
                    
                    // Upcoming Plans Section
                    UpcomingPlansView(
                        activePlan: viewModel.activeTrainingPlan, // Pass the optional plan
                        backgroundColor: cardBackgroundColor,
                        secondaryTextColor: secondaryTextColor,
                        accentColor: accentColor
                    )
                    .padding(.horizontal)
                    
                    Spacer(minLength: 90) // Add space so content doesn't hide behind tabbar AND overlays
                }
                .padding(.top)
            }
            .background(backgroundColor.ignoresSafeArea())
            // Allow content to scroll slightly under custom TabBar if needed
            // .ignoresSafeArea(.container, edges: .bottom)
            
            
            //MARK: - Overlays (Add Workout & Detail)
            if viewModel.showAddWorkout || viewModel.showWorkoutDetail {
                overlayBackground
                    .ignoresSafeArea()
                    .onTapGesture { // Allow dismissing by tapping background
                        viewModel.dismissAddWorkout()
                        viewModel.dismissWorkoutDetail()
                    }
                    .zIndex(1) // Ensure background is behind the foreground views
            }
            
            if viewModel.showAddWorkout {
                AddWorkoutView(
                    onDismiss: viewModel.dismissAddWorkout,
                    onSave: viewModel.saveWorkout // Pass the save function directly
                )
                .padding(.horizontal, 20) // Add padding so it doesn't touch edges
                .padding(.vertical, 50) // Adjust vertical padding
                .transition(.move(edge: .bottom).combined(with: .opacity)) // Animation from bottom
                .zIndex(2) // Ensure AddWorkout is above the overlay background
            }
            
            if let workout = viewModel.selectedWorkoutForDetail, viewModel.showWorkoutDetail {
                WorkoutDetailView(
                    workout: workout,
                    onDismiss: viewModel.dismissWorkoutDetail
                )
                .padding(.horizontal, 20)
                .padding(.vertical, 100) // Adjust padding as needed
                .transition(.scale.combined(with: .opacity)) // Scale/fade animation
                .zIndex(2) // Ensure DetailView is above the overlay background
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.showAddWorkout) // Animate changes
        .animation(.easeInOut(duration: 0.3), value: viewModel.showWorkoutDetail)
        .preferredColorScheme(.dark) // Apply dark mode preference
    }
}


#Preview {
    TrackerView()
}
