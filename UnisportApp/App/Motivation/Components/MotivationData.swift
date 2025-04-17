//
//  MotivationData.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//

import Foundation

// Static data source for now
struct MotivationData {

    static let onboardingPages: [OnboardingPageData] = [
        OnboardingPageData(imageName: "heart.fill", title: "Share motivation - get support!", description: "Connect with fellow athletes and share your journey."),
        OnboardingPageData(imageName: "heart.fill", title: "Write a short letter of support to another athlete. Your words can inspire someone!", description: "How to send"), // Description seems mismatched in screenshot, using TЗ logic
        OnboardingPageData(imageName: "heart.fill", title: "All emails are moderated to create a positive atmosphere.", description: "Community first"), // Adding descriptive text
        OnboardingPageData(imageName: "heart.fill", title: "Read messages from others and recharge your batteries!", description: "Get inspired") // Adding descriptive text
    ]

    static let motivationalQuotes: [MotivationalQuote] = [
        MotivationalQuote(text: "Remember, every champion was once a beginner who refused to give up. Your dedication today shapes your success tomorrow. Keep pushing your limits! 💪", timestamp: "2 hours ago"),
        MotivationalQuote(text: "\"The pain of discipline weighs ounces, while the pain of regret weighs tons. Today's workout might be tough, but you've got this! 🎯\"", timestamp: "5 hours ago"),
        MotivationalQuote(text: "\"Small progress is still progress. Celebrate every milestone, no matter how tiny. You're becoming stronger with each step! 🌟\"", timestamp: "Yesterday"),
        MotivationalQuote(text: "It was tough getting up for the run today, but I did it! Small victory over myself.", timestamp: "Yesterday"),
        MotivationalQuote(text: "Don't compare your chapter 1 to someone else's chapter 20. Just keep going.", timestamp: "2 days ago"),
        MotivationalQuote(text: "Remember why you started. On days when motivation is low, discipline takes over.", timestamp: "2 days ago"),
        MotivationalQuote(text: "Every workout is an investment in your future health and strength.", timestamp: "3 days ago"),
        MotivationalQuote(text: "Missed a workout? It's okay. The important thing is to get back tomorrow, not quit.", timestamp: "3 days ago"),
        MotivationalQuote(text: "Even 15 minutes of activity is better than zero. Do what you can, where you are.", timestamp: "4 days ago"),
        MotivationalQuote(text: "The body achieves what the mind believes.", timestamp: "4 days ago"),
        MotivationalQuote(text: "Celebrate the small wins! Ran 1 minute longer? Did 1 more rep? You rock!", timestamp: "5 days ago"),
        MotivationalQuote(text: "Don't be afraid to be a beginner. Everyone started somewhere.", timestamp: "5 days ago"),
        MotivationalQuote(text: "Rest day is part of the plan too. Let those muscles recover.", timestamp: "6 days ago"),
        MotivationalQuote(text: "That post-workout soreness? Best kind of tired in the world.", timestamp: "6 days ago"),
        MotivationalQuote(text: "Someone right now is just dreaming of the ability to move. Appreciate what you have and use it!", timestamp: "1 week ago"),
        MotivationalQuote(text: "Focus on the process, not just the result. Enjoy the movement!", timestamp: "1 week ago"),
        MotivationalQuote(text: "If you can change your body, you can change anything!", timestamp: "8 days ago"),
        MotivationalQuote(text: "You are stronger than you think. Just take one more step, one more rep.", timestamp: "8 days ago")
    ]
}
