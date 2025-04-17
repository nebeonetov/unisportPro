//
//  RealmModel.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//


import Foundation
import RealmSwift

// Основная модель Плана Тренировок
class TrainingPlan: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String = "New Training Plan" // Добавлено поле для названия
    @Persisted var createdAt: Date = Date()
    @Persisted var status: PlanStatus = .active // Используем Enum для статуса
    @Persisted var days = RealmSwift.List<DayPlan>()

    // Computed property для удобства
    var isActive: Bool { status == .active }

    // Дата последнего дня в плане
    var endDate: Date? {
        days.sorted(by: { $0.date > $1.date }).first?.date
    }

    // Оставшиеся дни до конца плана
    var daysLeft: Int? {
        guard let endDate = endDate else { return nil }
        let calendar = Calendar.current
        // Считаем дни от начала сегодняшнего дня до конца дня endDate
        let startOfToday = calendar.startOfDay(for: Date())
        let endOfDayEndDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate) ?? endDate
        let components = calendar.dateComponents([.day], from: startOfToday, to: endOfDayEndDate)
        return max(0, components.day ?? 0) // Не показываем отрицательные дни
    }

    // Процент выполнения плана
    var completionPercentage: Double {
        let completedDays = days.filter { $0.isCompleted }.count
        return days.isEmpty ? 0.0 : (Double(completedDays) / Double(days.count)) * 100.0
    }
}

// Вложенная модель для Дня в Плане
class DayPlan: EmbeddedObject, ObjectKeyIdentifiable {
    @Persisted var id: UUID = UUID() // Для Identifiable в SwiftUI
    @Persisted var date: Date = Date()
    @Persisted var taskDescription: String = ""
    @Persisted var isCompleted: Bool = false
}

// Enum для статуса Плана
enum PlanStatus: String, PersistableEnum {
    case active // Текущий активный план
    case completed // План завершен (все дни isCompleted = true?) - Логику завершения нужно продумать
    case terminated // План прерван пользователем
}


class WorkoutEntry: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var date: Date = Date() // Stores the START of the day
    @Persisted var workoutDescription: String = ""
    @Persisted var moodRawValue: String? // Store WorkoutMood raw value
    @Persisted var notes: String?

    // Convenience property to get the mood enum
    var mood: WorkoutMood? {
        guard let rawValue = moodRawValue else { return nil }
        return WorkoutMood(rawValue: rawValue)
    }

    // Convenience initializer
    convenience init(date: Date, description: String, mood: WorkoutMood?, notes: String?) {
        self.init()
        // Ensure we store the start of the day for consistency
        self.date = Calendar.current.startOfDay(for: date)
        self.workoutDescription = description
        self.moodRawValue = mood?.rawValue
        self.notes = notes
    }
}

// Make sure WorkoutMood enum conforms to String raw value if not already done
/* Example:
 enum WorkoutMood: String, CaseIterable, Identifiable {
    case amazing = "Amazing"
    case good = "Good"
    // ... rest of the cases ...
 }
*/

//MARK: - Realm Model Block (User Profile)
// UserProfile.swift

import Foundation
import RealmSwift

class UserProfile: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String = "currentUserProfile" // Use a fixed ID for singleton
    @Persisted var userName: String = "Anton" // Default name
    @Persisted var userEmail: String = "anton@email.com" // Default email
    @Persisted var avatarImageData: Data? // Store image data directly (use optional Data)

    // Computed properties for stats (read-only from ProfileView perspective)
    // These are NOT persisted, they should be calculated in ViewModel based on other Realm objects.
    // We remove direct persisted stats as they should be derived.

    // Default setup (Singleton Pattern for simplicity)
    static func getOrCreate(in realm: Realm) -> UserProfile {
        if let existing = realm.object(ofType: UserProfile.self, forPrimaryKey: "currentUserProfile") {
            return existing
        } else {
            let newProfile = UserProfile()
            try? realm.write {
                realm.add(newProfile)
            }
            return newProfile
        }
    }
}
