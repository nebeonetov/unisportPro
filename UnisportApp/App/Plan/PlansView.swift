//
//  PlansView.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//

import SwiftUI
import RealmSwift

struct PlansView: View {
    @StateObject private var viewModel = PlansViewModel()
    @State private var showingCreatePlan = false
    
    //MARK: - Colors
    private let backgroundColor = Color(red: 34/255, green: 34/255, blue: 34/255)
    private let cardBackgroundColor = Color.black.opacity(0.25)
    private let accentColor = Color(red: 0.22, green: 0.85, blue: 0.32)
    private let secondaryTextColor = Color.gray
    
    var body: some View {
        NavigationView { // Keep this NavigationView
            ScrollView {
                HStack {
                    Text("Plans")
                        .font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                    Spacer()
                    if let _ = viewModel.activePlan {
                        
                    } else {
                        Button {
                            showingCreatePlan = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(accentColor)
                        }
                    }
                    
                }
                .padding(.horizontal).padding(.top)
                
                VStack(alignment: .leading, spacing: 25) {
                   
                    if let plan = viewModel.activePlan {
                        ActivePlanCard(plan: plan, backgroundColor: cardBackgroundColor, accentColor: accentColor)
                            .padding(.horizontal)
                        
                        ThisWeekView(accentColor: accentColor, secondaryTextColor: secondaryTextColor)
                            .padding(.horizontal)
                        
                        TodaysActivitiesView(activities: viewModel.todaysActivities, backgroundColor: cardBackgroundColor, accentColor: accentColor)
                            .padding(.horizontal)
                        TerminatePlanButton(action: viewModel.terminateActivePlan, accentColor: accentColor)
                            .padding(.horizontal)
                    } else {
                        EmptyPlansView(
                            backgroundColor: cardBackgroundColor,
                            accentColor: accentColor,
                            action: { showingCreatePlan = true }
                        )
                        .padding(.horizontal).padding(.top, 50)
                    }
                    
                    
                    //MARK: - Previous Plans Section (Modified for Navigation)
                    PreviousPlansSection( // Renamed from PreviousPlansView for clarity
                        plans: viewModel.previousPlans,
                        backgroundColor: cardBackgroundColor,
                        secondaryTextColor: secondaryTextColor
                    )
                    .padding(.horizontal)
                    
                    Spacer(minLength: 20)
                }
                .padding(.top)
            }
            .background(backgroundColor.ignoresSafeArea())
            .sheet(isPresented: $showingCreatePlan) {
                CreatePlanView(onSave: { viewModel.updatePublishedPlans() })
            }
            .onAppear {
                viewModel.updatePublishedPlans()
            }
            .preferredColorScheme(.dark)
        }
        .tint(.white)
        .navigationViewStyle(.stack) // Use stack style
    }
}

//MARK: - Previous Plans Section Subview (With NavigationLink)
struct PreviousPlansSection: View {
    // Use ObservedResults for automatic updates if plans is a large/frequently changing list
    // Or pass the array from the ViewModel as done previously
    let plans: [TrainingPlan] // Array passed from ViewModel
    let backgroundColor: Color
    let secondaryTextColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            if !plans.isEmpty {
                Text("Previous Plans")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                
                VStack(spacing: 10) {
                    ForEach(plans) { plan in
                        // Ensure plan is valid before creating NavigationLink
                        if !plan.isInvalidated {
                            // ---> WRAP Row in NavigationLink <---
                            NavigationLink(destination: PlanDetailView(plan: plan)) {
                                PreviousPlanRow(plan: plan, backgroundColor: backgroundColor, secondaryTextColor: secondaryTextColor)
                            }
                        }
                    }
                }
            }
        }
    }
}


//MARK: - Previous Plan Row Subview (Extracted for clarity)
struct PreviousPlanRow: View {
    @ObservedRealmObject var plan: TrainingPlan // Observe changes to the specific plan row might represent
    let backgroundColor: Color
    let secondaryTextColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: plan.status == .terminated ? "figure.walk.circle" : "flag.checkered.circle")
                .foregroundColor(secondaryTextColor).frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(plan.title)
                    .font(.subheadline).fontWeight(.medium).foregroundColor(.white)
                Text(plan.status == .terminated ? "Terminated \(plan.createdAt, style: .date)" : "Completed \(plan.createdAt, style: .date)")
                    .font(.caption).foregroundColor(secondaryTextColor)
            }
            Spacer()
            Image(systemName: "chevron.right") // Chevron provided by NavigationLink automatically usually
                .foregroundColor(.gray)
                .opacity(0.5) // Make it subtle as NavLink adds one
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(10)
        // Add opacity animation if plan gets invalidated while row is visible
        .opacity(plan.isInvalidated ? 0.5 : 1.0)
        .animation(.default, value: plan.isInvalidated)
    }
}

//struct PlansView: View {
//    @StateObject private var viewModel = PlansViewModel()
//    @State private var showingCreatePlan = false
//
//    //MARK: - Colors
//    private let backgroundColor = Color(red: 34/255, green: 34/255, blue: 34/255)
//    private let cardBackgroundColor = Color.black.opacity(0.25)
//    private let accentColor = Color(red: 0.22, green: 0.85, blue: 0.32)
//    private let secondaryTextColor = Color.gray
//
//    var body: some View {
//        NavigationView {
//            ScrollView {
//
//                VStack(alignment: .leading, spacing: 25) {
//                    HStack {
//                        Text("Plans")
//                            .font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
//                        Spacer()
//                        Button {
//                            showingCreatePlan = true
//                        } label: {
//                            Image(systemName: "plus.circle.fill")
//                                .font(.title2)
//                                .foregroundColor(accentColor)
//                        }
//                    }
//                    .padding(.horizontal).padding(.top)
//
//                    if let plan = viewModel.activePlan {
//                        ActivePlanCard(plan: plan, backgroundColor: cardBackgroundColor, accentColor: accentColor)
//                            .padding(.horizontal)
//
//                        ThisWeekView(accentColor: accentColor, secondaryTextColor: secondaryTextColor)
//                            .padding(.horizontal)
//
//                        TodaysActivitiesView(activities: viewModel.todaysActivities, backgroundColor: cardBackgroundColor, accentColor: accentColor)
//                            .padding(.horizontal)
//
//                        TerminatePlanButton(action: viewModel.terminateActivePlan, accentColor: accentColor)
//                            .padding(.horizontal)
//                    } else {
//                        EmptyPlansView(
//                            backgroundColor: cardBackgroundColor,
//                            accentColor: accentColor,
//                            action: { showingCreatePlan = true }
//                        )
//                        .padding(.horizontal)
//                        .padding(.top, 50) // Add more top padding for empty state
//                    }
//
//                    PreviousPlansView(plans: viewModel.previousPlans, backgroundColor: cardBackgroundColor, secondaryTextColor: secondaryTextColor)
//                        .padding(.horizontal)
//
//                    Spacer(minLength: 20) // Add space at the bottom
//                }
//                .padding(.top) // Padding for the whole scroll content
//            }
//            .background(backgroundColor.ignoresSafeArea())
//
//            .sheet(isPresented: $showingCreatePlan) {
//                 // Present CreatePlanView as a sheet or navigation link
//                 //NavigationView { CreatePlanView() } // Wrap in NavigationView if using navigation modifiers inside
//                 CreatePlanView(onSave: {
//                     viewModel.updatePublishedPlans() // Обновить список после сохранения нового плана
//                 })
//            }
//            .onAppear {
//                // Возможно, потребуется обновить данные при появлении экрана,
//                // если @ObservedResults не срабатывает как ожидалось.
//                 viewModel.updatePublishedPlans()
//            }
//             .preferredColorScheme(.dark)
//        }
//         .navigationViewStyle(.stack) // Recommended for consistency
//    }
//}

//MARK: - Previews
struct PlansView_Previews: PreviewProvider {
    static var previews: some View {
        // It's difficult to preview Realm-dependent views accurately
        // without setting up mock Realm data in memory.
        // Provide a basic preview.
        PlansView()
        // Add mock view model if needed for better preview
        // .environmentObject(MockPlansViewModel())
            .preferredColorScheme(.dark)
    }
}
