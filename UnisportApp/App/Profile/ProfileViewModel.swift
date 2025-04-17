//
//  ProfileViewModel.swift
//  UnisportApp
//
//  Created by D K on 16.04.2025.
//


import Foundation
import RealmSwift
import SwiftUI // For Image, Published, etc.
import Combine // For observing Realm object changes

@MainActor
class ProfileViewModel: ObservableObject {

    // Published properties for the View
    @Published var userName: String = ""
    @Published var userEmail: String = ""
    @Published var avatarImage: Image? = nil // To display the image
    @Published var totalTrainings: Int = 0
    @Published var currentStreak: Int = 0 // Will be same as totalTrainings for now
    @Published var maxStreak: Int = 0 // Will be same as totalTrainings for now
    @Published var motivationsSent: Int = 0 // Always 0 for now
    @Published var competitionsCompleted: Int = 0

    // Photo Picker State
    @Published var showingImagePicker = false
    @Published var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary // Default

    // Realm specific properties
    private var realm: Realm?
    private var userProfileToken: NotificationToken?
    private var workoutToken: NotificationToken?
    private var planToken: NotificationToken?
    private var userProfile: UserProfile? // Hold the live object

    init() {
        setupRealm()
        loadUserProfile()
        setupObservers()
        calculateStatistics() // Initial calculation
    }

    deinit {
        userProfileToken?.invalidate()
        workoutToken?.invalidate()
        planToken?.invalidate()
    }

    private func setupRealm() {
        do {
            realm = try Realm()
        } catch {
            print("Error initializing Realm: \(error.localizedDescription)")
        }
    }

    private func loadUserProfile() {
        guard let realm = realm else { return }
        // Get or create the singleton profile
        self.userProfile = UserProfile.getOrCreate(in: realm)
        updatePublishedProfileData()
    }

    private func setupObservers() {
        guard let realm = realm, let profile = self.userProfile else { return }

        // Observe the UserProfile object for changes (e.g., avatar update)
        userProfileToken = profile.observe { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .change(_, _):
                print("UserProfile changed, updating UI.")
                self.updatePublishedProfileData()
            case .deleted:
                print("UserProfile deleted.")
                // Handle deletion, maybe recreate?
                self.userProfile = nil // Or reload/recreate
                self.clearPublishedProfileData()
            case .error(let error):
                print("Error observing UserProfile: \(error)")
            }
        }

        // Observe Workouts for Total Trainings calculation
        let workoutResults = realm.objects(WorkoutEntry.self)
        workoutToken = workoutResults.observe { [weak self] _ in
             print("Workout changes detected, recalculating stats.")
             self?.calculateStatistics()
        }

        // Observe Plans for Competitions Completed calculation
        let planResults = realm.objects(TrainingPlan.self)
        planToken = planResults.observe { [weak self] _ in
             print("Plan changes detected, recalculating stats.")
             self?.calculateStatistics()
        }
    }

    // Update UI properties from the Realm UserProfile object
    private func updatePublishedProfileData() {
        guard let profile = userProfile, !profile.isInvalidated else {
            clearPublishedProfileData()
            return
        }
        self.userName = profile.userName
        self.userEmail = profile.userEmail
        if let imageData = profile.avatarImageData, let uiImage = UIImage(data: imageData) {
            self.avatarImage = Image(uiImage: uiImage)
        } else {
            self.avatarImage = nil // Use placeholder in the View
        }
    }

     // Clear UI fields if profile is deleted or invalid
     private func clearPublishedProfileData() {
          self.userName = "N/A"
          self.userEmail = "N/A"
          self.avatarImage = nil
     }

    // Calculate statistics based on other Realm data
    private func calculateStatistics() {
        guard let realm = realm else {
            // Reset stats if realm is unavailable
             self.totalTrainings = 0
             self.currentStreak = 0
             self.maxStreak = 0
             self.motivationsSent = 0
             self.competitionsCompleted = 0
             print("Realm unavailable, stats reset.")
            return
        }

        // Total Trainings = Count of all WorkoutEntry objects
        self.totalTrainings = realm.objects(WorkoutEntry.self).count
        print("Calculated Total Trainings: \(self.totalTrainings)")

        // Current/Max Streak = Total Trainings (as per requirement)
        // TODO: Implement actual streak logic later if needed
        self.currentStreak = self.totalTrainings
        self.maxStreak = self.totalTrainings
        print("Calculated Streaks: \(self.currentStreak)")


        // Motivations = 0 (as per requirement)
        self.motivationsSent = 0
        print("Calculated Motivations: \(self.motivationsSent)")


        // Competitions Completed = Count of non-active TrainingPlan objects
        self.competitionsCompleted = realm.objects(TrainingPlan.self).filter("status != %@", PlanStatus.active.rawValue).count
        print("Calculated Competitions Completed: \(self.competitionsCompleted)")

    }

    // --- Image Handling ---

    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        self.imagePickerSourceType = sourceType
        self.showingImagePicker = true
    }

    func saveAvatarImage(_ image: UIImage?) {
        guard let realm = realm,
              let profile = self.userProfile?.thaw(), // Get mutable copy
              let image = image,
              // Compress image to save space (adjust compression quality)
              let imageData = image.jpegData(compressionQuality: 0.7) else {
            print("Error preparing image data or getting profile.")
            return
        }

        // Ensure the profile is still valid before writing
        guard !profile.isInvalidated else {
             print("Profile object invalidated before saving image.")
             return
        }

        do {
            try realm.write {
                profile.avatarImageData = imageData
                print("Avatar image saved successfully.")
            }
            // UI update will happen via the profile observer
            // updatePublishedProfileData() // No need to call manually
        } catch {
            print("Error saving avatar image to Realm: \(error.localizedDescription)")
        }
    }
}
