//
//  TrackerViewModel.swift
//  UnisportApp
//
//  Created by D K on 16.04.2025.
//

import Foundation
import RealmSwift
import Combine
import SwiftUI

struct MonthlyDynamicsData: Identifiable { // Keep this if using dynamics chart
    let id = UUID()
    let monthAbbreviation: String
    let percentage: Double
}

@MainActor
class TrackerViewModel: ObservableObject {

    @ObservedResults(WorkoutEntry.self) var allWorkoutEntries
    @Published var workoutsByDate: [Date: WorkoutEntry] = [:]
    @Published var todaysWorkout: WorkoutEntry? = nil
    @Published var showAddWorkout = false
    @Published var showWorkoutDetail = false
    @Published var selectedWorkoutForDetail: WorkoutEntry? = nil
    @Published var monthlyDynamics: [MonthlyDynamicsData] = [] // Keep for dynamics
    @Published var hasAnyWorkouts: Bool = false // Keep for dynamics
    @Published var activeTrainingPlan: TrainingPlan? = nil

    private var realm: Realm?
    private var notificationToken: NotificationToken?
    
    private var workoutNotificationToken: NotificationToken?
        private var planNotificationToken: NotificationToken?

    init() {
        setupRealm()
        setupObservers()
        updatePublishedData()
    }

    deinit {
        notificationToken?.invalidate()
        planNotificationToken?.invalidate() // Invalidate plan token too

    }

    private func setupRealm() {
        do {
            realm = try Realm()
        } catch {
            print("Error initializing Realm: \(error.localizedDescription)")
        }
    }

    private func setupObservers() {
            guard let realm = realm else { return }

            // Observer for Workouts
            let workoutResults = realm.objects(WorkoutEntry.self)
            workoutNotificationToken = workoutResults.observe { [weak self] (changes: RealmCollectionChange) in
                 DispatchQueue.main.async {
                     guard let self = self else { return }
                     // Workout changes might affect plan progress indirectly, so update all
                     self.updatePublishedData()
                 }
            }

            // ---> NEW: Observer for Training Plans <---
            let planResults = realm.objects(TrainingPlan.self)
            planNotificationToken = planResults.observe { [weak self] (changes: RealmCollectionChange) in
                 DispatchQueue.main.async {
                      guard let self = self else { return }
                      print("Realm TrainingPlan Change detected")
                      // Plan changes definitely affect the active plan, update all
                      self.updatePublishedData()
                 }
            }
        }

    private func updatePublishedData() {
        let currentWorkoutEntries = realm?.objects(WorkoutEntry.self) ?? self.allWorkoutEntries
                self.hasAnyWorkouts = !currentWorkoutEntries.isEmpty

                // Update workout data (same as before)
                var newWorkoutsByDate: [Date: WorkoutEntry] = [:]
        currentWorkoutEntries.forEach { entry in
            guard !entry.isInvalidated else { return }
            let startOfDayKey = Calendar.current.startOfDay(for: entry.date) // Key is startOfDay
            newWorkoutsByDate[startOfDayKey] = entry
        }
        self.workoutsByDate = newWorkoutsByDate
                let startOfToday = Calendar.current.startOfDay(for: Date())
                self.todaysWorkout = self.workoutsByDate[startOfToday]
                self.monthlyDynamics = calculateMonthlyDynamicsAhead(entries: Array(currentWorkoutEntries))

                // ---> NEW: Find Active Training Plan <---
                // Access plans directly from Realm inside the update function
                self.activeTrainingPlan = realm?.objects(TrainingPlan.self).where {
                    $0.status == PlanStatus.active // Filter for active status
                }.first // Get the first (should be only one) active plan

                print("Active training plan found: \(self.activeTrainingPlan?.title ?? "None")")

                // --- Check Detail View ---
                if showWorkoutDetail, let selectedWorkout = selectedWorkoutForDetail {
                     if selectedWorkout.isInvalidated || realm?.object(ofType: WorkoutEntry.self, forPrimaryKey: selectedWorkout.id) == nil {
                         showWorkoutDetail = false
                         selectedWorkoutForDetail = nil
                    }
                }
    }

    // NEW: Calculate monthly dynamics (Keep if ClassDynamicsView is used)
    private func calculateMonthlyDynamicsAhead(entries: [WorkoutEntry]) -> [MonthlyDynamicsData] {
            // No need to calculate if no workouts exist? Or show empty bars? Let's calculate anyway.
            // guard !entries.isEmpty else { return [] } // Removed this guard to potentially show empty future bars

            let calendar = Calendar.current
            let today = Date()
            var dynamicsData: [MonthlyDynamicsData] = []
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MMM" // e.g., "Jan", "Feb"

            // Filter out invalidated entries once at the beginning
            let validEntries = entries.filter { !$0.isInvalidated }

            // Loop for the current month (i=0) and the next 5 months (i=1 to 5)
            for i in 0..<6 {
                // ---> CHANGE: Add 'i' months to today instead of subtracting <---
                guard let targetMonthDate = calendar.date(byAdding: .month, value: i, to: today),
                      let monthInterval = calendar.dateInterval(of: .month, for: targetMonthDate),
                      // Use range(of:in:for:) which returns Int? for days in month
                      let daysInMonth = calendar.range(of: .day, in: .month, for: targetMonthDate)?.count else {
                    print("Warning: Could not calculate month data for offset \(i)")
                    // Optionally add a placeholder for this month or skip
                    continue // Skip if month calculation fails
                }

                let monthStartDate = monthInterval.start
                let monthEndDate = monthInterval.end // dateInterval end is exclusive

                // Filter entries for the specific month interval
                // We still need to check past/current entries even for future months' calculations
                let entriesInMonth = validEntries.filter { entry in
                    // Ensure date comparison is correct using startOfDay if needed, but >= and < should work
                    let entryStartOfDay = calendar.startOfDay(for: entry.date)
                    return entryStartOfDay >= monthStartDate && entryStartOfDay < monthEndDate
                }


                // Count unique days with workouts within that month
                let workoutDaysInMonth = Set(entriesInMonth.map { calendar.startOfDay(for: $0.date) }).count

                let percentage = daysInMonth > 0 ? Double(workoutDaysInMonth) / Double(daysInMonth) : 0.0
                let monthAbbreviation = monthFormatter.string(from: monthStartDate)

                // ---> CHANGE: Append at the end for correct order [Current, Next, ...] <---
                dynamicsData.append(MonthlyDynamicsData(monthAbbreviation: monthAbbreviation, percentage: max(0.0, min(1.0, percentage)))) // Clamp percentage 0-1
            }

            return dynamicsData
        }
    // Use startOfDay for keys and lookups
    func workoutExists(for date: Date) -> Bool {
        let startOfDayKey = Calendar.current.startOfDay(for: date)
        return workoutsByDate[startOfDayKey] != nil
    }

    func getWorkout(for date: Date) -> WorkoutEntry? {
        let startOfDayKey = Calendar.current.startOfDay(for: date)
        return workoutsByDate[startOfDayKey]
    }

    func handleMarkWorkoutTap() {
        if todaysWorkout == nil {
            showAddWorkout = true
        }
    }

    // Save using startOfDay
    func saveWorkout(description: String, mood: WorkoutMood?, notes: String) {
        guard let realm = realm else { return }
        let today = Date()
        let startOfToday = Calendar.current.startOfDay(for: today) // Use start of day
        guard !workoutExists(for: startOfToday) else {
            self.showAddWorkout = false
            return
        }
        let newEntry = WorkoutEntry(date: startOfToday, description: description, mood: mood, notes: notes.isEmpty ? nil : notes)
        do {
            try realm.write { realm.add(newEntry) }
        } catch { print("Error saving workout: \(error.localizedDescription)") }
        self.showAddWorkout = false
    }

    // Use startOfDay for lookup
    func handleGridSquareTap(for date: Date) {
        let startOfDayKey = Calendar.current.startOfDay(for: date)
        if let workout = workoutsByDate[startOfDayKey], !workout.isInvalidated {
            selectedWorkoutForDetail = workout
            showWorkoutDetail = true
        } else {
             print("Tapped square for \(date) (key: \(startOfDayKey)), no valid workout found.")
        }
    }

     func dismissAddWorkout() { showAddWorkout = false }
     func dismissWorkoutDetail() { showWorkoutDetail = false; selectedWorkoutForDetail = nil }
}
