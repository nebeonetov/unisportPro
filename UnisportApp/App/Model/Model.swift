//
//  Model.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//

import Foundation

//MARK: - Sample Features Data Block
// (Can be in TrackerView, a separate Data file, or ViewModel)

struct Feature: Identifiable { // Assuming your model is named Feature now
    let id = UUID()
    let imageName: String // Placeholder name, we'll generate prompts
    let title: String
    let subtitle: String
    let detailedContent: String // Added for detail view
    let imagePrompt: String // Added for image generation
}





enum TipCategory: String, CaseIterable, Identifiable {
    case all = "All Tips"
    case running = "Running"
    case strength = "Strength"
    case nutrition = "Nutrition"
    case recovery = "Recovery"
    var id: String { self.rawValue }
}

struct Tip: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let authorName: String
    let authorTitle: String?
    let authorAvatarPlaceholder: String
    var contentImagePlaceholder: String // Now intended as image identifier/filename
    let category: TipCategory
    let isFeatured: Bool
    // ---> NEW Fields <---
    let detailedContent: String
    let imagePrompt: String
}

struct MotivationalQuote: Identifiable {
    let id = UUID()
    let text: String
    // Placeholder data for design matching
    let authorName: String = "From an anonymous athlete"
    let timestamp: String // e.g., "2 hours ago", "Yesterday"
    let likes: Int = Int.random(in: 10...50) // Random placeholder
    let comments: Int = Int.random(in: 2...10) // Random placeholder
    let avatarPlaceholder: String = "person.crop.circle.fill" // SF Symbol for placeholder
}

struct OnboardingPageData: Identifiable {
    let id = UUID()
    let imageName: String // e.g., "heart.fill"
    let title: String
    let description: String
}
