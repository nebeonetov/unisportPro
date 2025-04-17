//
//  PlansViewModel.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//


import Foundation
import RealmSwift
import Combine // For PassthroughSubject if needed for updates

class PlansViewModel: ObservableObject {
    @ObservedResults(TrainingPlan.self) var allPlans // Наблюдаем за всеми планами

    @Published var activePlan: TrainingPlan? = nil
    @Published var previousPlans: [TrainingPlan] = []
    @Published var todaysActivities: [DayPlan] = []
    // @Published var weekCompletion: [Bool] = Array(repeating: false, count: 7) // Example state for week view

    private var realm: Realm?
    private var notificationToken: NotificationToken?

    init() {
        setupRealm()
        observePlans()
    }

    private func setupRealm() {
        do {
            realm = try Realm()
        } catch {
            print("Error initializing Realm: \(error.localizedDescription)")
            // Handle error appropriately
        }
    }

    private func observePlans() {
        // Используем @ObservedResults, но можно и вручную настроить наблюдение
        // для более тонкого контроля, если потребуется.
        // Этот пример будет автоматически обновлять allPlans.
        // Нам нужно обновлять activePlan и previousPlans на основе allPlans.

        // Обновляем activePlan и previousPlans при изменении allPlans
        // Это можно сделать в didSet allPlans или через Combine.
        // Простой вариант: использовать computed properties или обновлять принудительно.
        // Обновление при инициализации и через Task/Publisher
        updatePublishedPlans()

        // Ручное наблюдение (альтернатива @ObservedResults или для сложных запросов)
         /*
         guard let realm = realm else { return }
         let results = realm.objects(TrainingPlan.self)
         notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
             guard let self = self else { return }
             switch changes {
             case .initial, .update:
                 self.updatePublishedPlans()
             case .error(let error):
                 print("Error observing Realm changes: \(error)")
             }
         }
         */
    }

    // Вызывается для обновления опубликованных свойств на основе данных из Realm
    func updatePublishedPlans() {
         DispatchQueue.main.async { // Обновления UI в главном потоке
             self.activePlan = self.allPlans.first(where: { $0.status == .active })
             self.previousPlans = self.allPlans.filter { $0.status == .completed || $0.status == .terminated }.sorted(by: { $0.createdAt > $1.createdAt })

             self.updateTodaysActivities()
             self.updateWeeklyCompletion() // Обновить состояние недели
         }
    }

    func updateTodaysActivities() {
        guard let plan = activePlan else {
            todaysActivities = []
            return
        }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        todaysActivities = plan.days.filter { calendar.isDate($0.date, inSameDayAs: today) }
    }

    // Логика для обновления состояния недели (пример)
    func updateWeeklyCompletion() {
       // TODO: Implement logic based on active plan's completed days for the current week
       // For example, iterate through the last 7 days, check if a DayPlan exists and isCompleted
       // self.weekCompletion = ...
    }


    // Терминировать активный план
    func terminateActivePlan() {
        guard let plan = activePlan, let realm = realm else { return }
        do {
            try realm.write {
                // Используем thawed для получения изменяемой копии, если объект заморожен
                 if let thawedPlan = plan.thaw() {
                     thawedPlan.status = .terminated
                     print("Plan \(thawedPlan.title) terminated.")
                 } else {
                     print("Could not thaw plan to terminate.")
                 }
            }
             updatePublishedPlans() // Обновить UI после изменения
        } catch {
            print("Error terminating plan: \(error.localizedDescription)")
        }
    }

    // Пример функции для отметки дня недели (если нужно будет изменять isCompleted у DayPlan)
    func toggleDayCompletion(for date: Date) {
         guard let plan = activePlan, let realm = realm, let thawedPlan = plan.thaw() else { return }
        do {
            try realm.write {
                 if let dayToToggle = thawedPlan.days.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
                     dayToToggle.isCompleted.toggle()
                     print("Toggled completion for \(date): \(dayToToggle.isCompleted)")
                 }
            }
            updatePublishedPlans() // Обновить UI (прогресс, галочки)
        } catch {
             print("Error toggling day completion: \(error.localizedDescription)")
        }

    }


    deinit {
        notificationToken?.invalidate() // Важно отменить наблюдение
    }
}
