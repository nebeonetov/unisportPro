//
//  TipsView.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//

import SwiftUI

//MARK: - Tips View
struct TipsView: View {

    //MARK: - Mock Data
    static let allTips: [Tip] = [
            // Latest
            Tip(
                title: "Nutrition Guide for Athletes",
                subtitle: "Timing is everything: optimize pre & post workout meals for results.", // Engaging subtitle
                authorName: "Emma Davis", authorTitle: nil, authorAvatarPlaceholder: "emmaImage",
                contentImagePlaceholder: "tip_athlete_meal_prep", // Image identifier
                category: .nutrition, isFeatured: false,
                detailedContent: """
                Optimize your workouts with smart nutrition timing! This guide explains the 'anabolic window' myth and reality. Learn ideal pre-workout meals (1-3 hours before) focusing on digestible carbs for energy without stomach upset. Discover post-workout essentials (within 1-2 hours) combining quality protein for muscle repair and complex carbs for glycogen replenishment. Includes sample meal ideas for strength vs. endurance training.
                """,
                imagePrompt: "Photo of a well-organized meal prep container showing a balanced athlete's meal: grilled chicken breast or tofu, quinoa or sweet potato, and steamed broccoli/peppers. Top-down view, clean presentation. Style: Food Photography."
            ),
            Tip(
                title: "Recovery Techniques",
                subtitle: "Speed up recovery & prevent overtraining with these key methods.", // Engaging subtitle
                authorName: "David Chen", authorTitle: nil, authorAvatarPlaceholder: "davidImage",
                contentImagePlaceholder: "tip_foam_rolling", // Image identifier
                category: .recovery, isFeatured: false,
                detailedContent: """
                Recovery is where gains happen! Explore techniques beyond just rest days. Learn the benefits of active recovery (like light cycling or swimming) to reduce muscle soreness, the crucial role of quality sleep (aim for 7-9 hours), basic foam rolling and massage gun techniques to release muscle tightness (myofascial release), and simple stress management practices (like meditation) that significantly impact physical recovery.
                """,
                imagePrompt: "Photo of an athlete using a foam roller or massage gun on their leg muscles after a workout, focused but relaxed expression, comfortable athletic wear, in a bright gym or home fitness area. Style: Fitness/Wellness Photography."
            ),
            Tip(
                title: "Building Leg Strength",
                subtitle: "Master compound lifts like squats & deadlifts for a powerful base.", // Engaging subtitle
                authorName: "Alex Johnson", authorTitle: nil, authorAvatarPlaceholder: "alexImage",
                contentImagePlaceholder: "tip_leg_squat", // Image identifier
                category: .strength, isFeatured: false,
                detailedContent: """
                Develop powerful legs for improved performance and injury resilience across all activities. This guide focuses on mastering fundamental compound movements: Squats (Back, Front, Goblet), Deadlifts (Conventional, Romanian), and Lunges (Forward, Reverse, Lateral). Learn the critical importance of proper form for safety and maximizing muscle activation. Understand progressive overload principles to apply for continuous strength gains.
                """,
                imagePrompt: "Side profile action shot of an athlete performing a barbell back squat or deadlift with excellent form in a well-equipped gym, emphasizing leg and glute muscles under tension. Strong, focused lighting. Style: Fitness Photography."
            ),
            Tip(
                title: "Improving Running Form",
                subtitle: "Run smoother, faster, & reduce injury risk with simple technique cues.", // Engaging subtitle
                authorName: "Coach Lisa", authorTitle: nil, authorAvatarPlaceholder: "lisaImage",
                contentImagePlaceholder: "tip_running_form", // Image identifier
                category: .running, isFeatured: false,
                detailedContent: """
                Run smoother, faster, and with fewer injuries! Learn key elements of efficient running form by focusing on actionable cues: maintaining an upright posture ('run tall'), optimizing your foot strike (aiming for midfoot landing under your center of gravity), increasing cadence slightly (more steps per minute, often around 170-180), and using a relaxed, compact arm swing. Includes simple drills like 'butt kicks' and 'high knees' to incorporate into warm-ups.
                """,
                imagePrompt: "Side view photo of a runner mid-stride on a scenic outdoor path or track, demonstrating good running form: upright posture, relaxed shoulders, mid-foot strike occurring under the hip, fluid motion. Natural lighting, slightly blurred background suggesting movement. Style: Sports Photography."
            )
        ]

    //MARK: - State
    @State private var selectedCategory: TipCategory = .all
    @State private var selectedTip: Tip? = nil
        @State private var showDetail: Bool = false
        @Namespace var tipAnimationNamespace

    //MARK: - Filtered Data
    private var featuredTips: [Tip] {
        TipsView.allTips.filter { $0.isFeatured && (selectedCategory == .all || $0.category == selectedCategory) }
    }

    private var latestTips: [Tip] {
        TipsView.allTips.filter { !$0.isFeatured && (selectedCategory == .all || $0.category == selectedCategory) }
    }

    //MARK: - Colors
    private let backgroundColor = Color(red: 34/255, green: 34/255, blue: 34/255)
    private let cardBackgroundColor = Color.black.opacity(0.25)
    private let accentColor = Color(red: 0.22, green: 0.85, blue: 0.32) // #38d951
    private let secondaryTextColor = Color.gray
    private let inactiveButtonColor = Color.black.opacity(0.3)
    
    

    var body: some View {
            // Use ZStack for detail overlay
            ZStack {
                 NavigationView {
                     ScrollView {
                         HStack {
                             HStack {
                                 Image(systemName: "bolt.fill")
                                     .foregroundColor(accentColor)
                                     .font(.title2) // Slightly smaller than title
                                 Text("Tips")
                                     .font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                             }
                             Spacer()
                            
                         }
                         .padding(.horizontal).padding(.top)
                         
                         VStack(alignment: .leading, spacing: 25) {
                             // Filter Buttons ...
                             TipFilterButtons(selectedCategory: $selectedCategory, accentColor: accentColor, inactiveColor: inactiveButtonColor)
                                  .padding(.horizontal)

                             // Featured Tips Section (Pass Namespace & Action)
                             if !featuredTips.isEmpty {
                                  FeaturedTipsSection(
                                       tips: featuredTips,
                                       cardBackgroundColor: cardBackgroundColor,
                                       secondaryTextColor: secondaryTextColor,
                                       namespace: tipAnimationNamespace, // Pass namespace
                                       onSelectTip: { tip in // Pass selection handler
                                            selectTipForDetail(tip)
                                       }
                                  )
                             }

                             // Latest Tips Section (Pass Namespace & Action)
                             if !latestTips.isEmpty {
                                  LatestTipsSection(
                                       tips: latestTips,
                                       cardBackgroundColor: cardBackgroundColor,
                                       secondaryTextColor: secondaryTextColor,
                                       namespace: tipAnimationNamespace, // Pass namespace
                                       onSelectTip: { tip in // Pass selection handler
                                            selectTipForDetail(tip)
                                       }
                                  )
                                  .padding(.horizontal)
                             }

                             // Placeholder if no tips match filter ...
                         }
                         .padding(.top)
                     }
                     .background(backgroundColor.ignoresSafeArea())
                 } // End NavigationView
                  .navigationViewStyle(.stack)
                  .preferredColorScheme(.dark)
                  .zIndex(0) // Keep main view at bottom layer

                 //MARK: - Detail View Overlay
                 if showDetail, let tip = selectedTip {
                      TipDetailView(
                           tip: tip,
                           showDetail: $showDetail,
                           namespace: tipAnimationNamespace
                      )
                      .zIndex(1) // Detail view on top
                      .transition(.opacity.animation(.easeInOut(duration: 0.2)))
                 }

            } // End ZStack
             // Observe showDetail for animation if needed globally
             .animation(.default, value: showDetail)
        }

        // Helper function to handle tip selection and trigger animation
        private func selectTipForDetail(_ tip: Tip) {
             withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                  selectedTip = tip
                  showDetail = true
             }
        }
    }
//MARK: - Filter Buttons View
struct TipFilterButtons: View {
    @Binding var selectedCategory: TipCategory
    let accentColor: Color
    let inactiveColor: Color

    // Define specific categories to show as buttons
    let buttonCategories: [TipCategory] = [.all, .running, .strength] // Add more if needed

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(buttonCategories) { category in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                           selectedCategory = category
                        }
                    } label: {
                        Text(category.rawValue)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .foregroundColor(selectedCategory == category ? .black : .white)
                            .background(selectedCategory == category ? accentColor : inactiveColor)
                            .cornerRadius(20)
                    }
                }
            }
        }
    }
}


//MARK: - Featured Tips Section View
struct FeaturedTipsSection: View {
    let tips: [Tip]
    let cardBackgroundColor: Color
    let secondaryTextColor: Color
    // ---> NEW Parameters <---
    let namespace: Namespace.ID
    let onSelectTip: (Tip) -> Void // Closure to call when tip is selected

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Featured Tips").font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(tips) { tip in
                         Button { onSelectTip(tip) } label: { // Use button
                              FeaturedTipCardView(
                                   tip: tip,
                                   backgroundColor: cardBackgroundColor,
                                   secondaryTextColor: secondaryTextColor,
                                   namespace: namespace // Pass namespace
                              )
                         }
                         .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal).padding(.bottom, 5)
            }
        }
    }
}

//MARK: - Featured Tip Card View

struct FeaturedTipCardView: View {
    let tip: Tip
    let backgroundColor: Color
    let secondaryTextColor: Color
    let namespace: Namespace.ID // Receive namespace

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(tip.authorAvatarPlaceholder)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white.opacity(0.8))
                    .background(Color.gray.opacity(0.5))
                    .clipShape(Circle())
                    .matchedGeometryEffect(id: "\(tip.id)_author", in: namespace, properties: .position, anchor: .topLeading, isSource: true)

                VStack(alignment: .leading) {
                    Text(tip.authorName)
                        .font(.headline)
                        .foregroundColor(.white)
                    if let title = tip.authorTitle {
                        Text(title)
                            .font(.caption)
                            .foregroundColor(secondaryTextColor)
                    }
                }
                .matchedGeometryEffect(id: "\(tip.id)_authorName", in: namespace, properties: .position, anchor: .topLeading, isSource: true)
                Spacer()
            }
            .padding([.horizontal, .top])
            .padding(.bottom, 10)


            Image(tip.contentImagePlaceholder)
                .resizable()
                .scaledToFill()
                .frame(height: 160)
                .cornerRadius(10).padding(.horizontal)
                 // ---> Matched Geometry ID for Image <---
                 .matchedGeometryEffect(id: "\(tip.id)_image", in: namespace)

            VStack(alignment: .leading, spacing: 5) { // Text Content
                
                Text(tip.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(2) // Allow for longer titles
                    .matchedGeometryEffect(id: "\(tip.id)_title", in: namespace)

                Text(tip.subtitle)
                    .font(.subheadline)
                    .foregroundColor(secondaryTextColor)
                    .lineLimit(3)
                    .matchedGeometryEffect(id: "\(tip.id)_subtitle", in: namespace)

            }
            .padding([.horizontal, .bottom]).padding(.top, 10)
        }
        .background(backgroundColor) // Apply background modifier
        .cornerRadius(15)
         // ---> Matched Geometry ID for Card Background <---
         .background(
              RoundedRectangle(cornerRadius: 15).fill(backgroundColor) // Match shape and color
                  .matchedGeometryEffect(id: "\(tip.id)_card", in: namespace)
         )
         .frame(width: 300, height: 300)
    }
}


//MARK: - Latest Tips Section View
struct LatestTipsSection: View {
     let tips: [Tip]
     let cardBackgroundColor: Color
     let secondaryTextColor: Color
     // ---> NEW Parameters <---
     let namespace: Namespace.ID
     let onSelectTip: (Tip) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
             Text("Latest Tips")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            LazyVStack(spacing: 15) {
                 ForEach(tips) { tip in
                      Button { onSelectTip(tip) } label: { // Use button
                           LatestTipCardView(
                                tip: tip,
                                backgroundColor: cardBackgroundColor,
                                secondaryTextColor: secondaryTextColor,
                                namespace: namespace // Pass namespace
                           )
                      }
                      .buttonStyle(.plain)
                 }
            }
        }
    }
}

//MARK: - Latest Tip Card View
struct LatestTipCardView: View {
    let tip: Tip
    let backgroundColor: Color
    let secondaryTextColor: Color
    let namespace: Namespace.ID // Receive namespace

    var body: some View {
        HStack(spacing: 15) {
            Image(tip.contentImagePlaceholder)
                .resizable()
                .scaledToFill()
                 .frame(width: 80, height: 80)
                 .cornerRadius(10)
                 // ---> Matched Geometry ID for Image <---
                 .matchedGeometryEffect(id: "\(tip.id)_image", in: namespace)

            VStack(alignment: .leading, spacing: 6) { // Text Content & Author
                HStack {
                    Image(tip.authorAvatarPlaceholder)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white.opacity(0.7))
                        .background(Color.gray.opacity(0.4))
                        .clipShape(Circle())
                        .matchedGeometryEffect(id: "\(tip.id)_author", in: namespace, properties: .position, anchor: .topLeading, isSource: true)
                    Text(tip.authorName)
                        .font(.caption)
                        .foregroundColor(secondaryTextColor)
                        .matchedGeometryEffect(id: "\(tip.id)_authorName", in: namespace, properties: .position, anchor: .topLeading, isSource: true)

                    Spacer() // Push content left
                }

                Text(tip.title) /* ... */
                    .font(.subheadline) // Slightly smaller than featured title
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .matchedGeometryEffect(id: "\(tip.id)_title", in: namespace)
                Text(tip.subtitle) /* ... */
                    .font(.caption) // Smaller subtitle
                    .foregroundColor(secondaryTextColor)
                    .lineLimit(2)
                    .matchedGeometryEffect(id: "\(tip.id)_subtitle", in: namespace)
            }
            Spacer()
        }
        .padding()
        .background(backgroundColor) // Apply background modifier
        .cornerRadius(15)
         // ---> Matched Geometry ID for Card Background <---
         .background(
              RoundedRectangle(cornerRadius: 15).fill(backgroundColor)
                  .matchedGeometryEffect(id: "\(tip.id)_card", in: namespace)
         )
    }
}

//MARK: - Previews
struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        TipsView()
            // Inject into a TabView or NavigationView for realistic preview
            .environmentObject(MainViewModel()) // Example if using EnvironmentObject later
    }
}

// Example ViewModel if needed later
class MainViewModel: ObservableObject {
    // Add shared state if necessary across views
}
