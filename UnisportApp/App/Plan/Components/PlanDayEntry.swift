//
//  PlanDayEntry.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//


import Foundation
import RealmSwift
import SwiftUI // For Published, State etc.

// Structure to hold temporary day data in the UI before saving to Realm
struct PlanDayEntry: Identifiable {
    let id = UUID() // For ForEach
    var date: Date
    var taskDescription: String = ""
    var isDateFocused: Bool = false // Flag to manage DatePicker presentation
}

class CreatePlanViewModel: ObservableObject {
    @Published var planTitle: String = ""
    @Published var dayEntries: [PlanDayEntry] = []

    private var realm: Realm?

    init() {
        setupRealm()
        // Add the first day entry automatically when the view model is created
        addDay()
    }

     private func setupRealm() {
        do {
            realm = try Realm()
        } catch {
            print("Error initializing Realm: \(error.localizedDescription)")
            // Handle error appropriately
        }
    }

    // Add a new day entry
    func addDay() {
        let nextDate: Date
        if let lastDate = dayEntries.last?.date {
            nextDate = Calendar.current.date(byAdding: .day, value: 1, to: lastDate) ?? Date()
        } else {
            nextDate = Calendar.current.startOfDay(for: Date()) // Start with today for the first entry
        }
        dayEntries.append(PlanDayEntry(date: nextDate))
    }

    // Update the date for a specific entry and subsequent entries
    func updateDate(for entryId: UUID, newDate: Date) {
        guard let index = dayEntries.firstIndex(where: { $0.id == entryId }) else { return }

        let calendar = Calendar.current
        var currentDate = calendar.startOfDay(for:newDate) // Ensure we use the start of the day

        // Update the selected day
        dayEntries[index].date = currentDate

        // Update subsequent days
        for i in (index + 1)..<dayEntries.count {
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
            dayEntries[i].date = currentDate
        }
    }

    // Save the plan to Realm
    func savePlan() -> Bool {
        guard let realm = realm, !planTitle.isEmpty, !dayEntries.isEmpty else {
             print("Cannot save plan: Title empty, no days, or Realm not available.")
             return false // Indicate failure
        }

        let newPlan = TrainingPlan()
        newPlan.title = self.planTitle
        newPlan.status = .active // New plans are active by default

        // Convert PlanDayEntry to DayPlan (EmbeddedObject)
        let dayPlanObjects = dayEntries.map { entry -> DayPlan in
            let dayPlan = DayPlan()
            dayPlan.date = entry.date
            dayPlan.taskDescription = entry.taskDescription
            dayPlan.isCompleted = false // New tasks are not completed
            return dayPlan
        }
        newPlan.days.append(objectsIn: dayPlanObjects)

        do {
            // Deactivate any existing active plans before saving the new one
            let activePlans = realm.objects(TrainingPlan.self).filter("status == %@", PlanStatus.active.rawValue)
            try realm.write {
                 for plan in activePlans {
                     // Ensure you get a mutable copy if the object is frozen
                      if let thawedPlan = plan.thaw() {
                          thawedPlan.status = .terminated // Or .completed depending on logic
                          print("Deactivated existing plan: \(thawedPlan.title)")
                      }
                 }
                // Add the new plan
                realm.add(newPlan)
                print("Plan '\(newPlan.title)' saved successfully with \(newPlan.days.count) days.")
            }
            return true // Indicate success
        } catch {
            print("Error saving plan to Realm: \(error.localizedDescription)")
            return false // Indicate failure
        }
    }
}
