//
//  FeaturedTipsView.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//

//MARK: - Featured Tips View Block (With Detail View Logic)
// FeaturedTipsView.swift

import SwiftUI

extension View {
    func size() -> CGSize {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        return window.screen.bounds.size
    }
}

struct FeaturedTipsView: View {
    // Use the sampleFeatures defined above
    @State var features: [Feature] = []
    let backgroundColor: Color // Passed from parent (TrackerView)
    let secondaryTextColor: Color // Passed from parent

    @State private var selectedFeature: Feature? = nil
    @State private var showDetail: Bool = false
    // Namespace for matched geometry effect
    @Namespace var animationNamespace

    var body: some View {
        ZStack { // Use ZStack to overlay the detail view
            //MARK: - Main Content (Cards)
            VStack(alignment: .leading) {
                Text("Featured Tips")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(features) { feature in
                            // Wrap Card in Button or use onTapGesture
                            Button {
                                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                    selectedFeature = feature
                                    showDetail = true
                                }
                            } label: {
                                TipCardView(
                                    feature: feature, // Pass feature data
                                    secondaryTextColor: secondaryTextColor,
                                    namespace: animationNamespace // Pass namespace
                                )
                            }
                            .buttonStyle(.plain) // Use plain style to avoid default button styling
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                }
            }
            .zIndex(0) // Keep main content at the bottom layer

            //MARK: - Detail View Overlay
            if showDetail, let feature = selectedFeature {
                FeatureDetailView(
                    feature: feature,
                    showDetail: $showDetail, // Pass binding
                    namespace: animationNamespace // Pass namespace
                )
                .zIndex(1) // Ensure detail view is on top
                // Add transition for the background fade if desired
                 .transition(.opacity.animation(.easeInOut(duration: 0.2)))
            }
        }
        .onAppear {
            features = sampleFeatures
        }
        // Apply overall animation observation if needed, but transitions handle it
        // .animation(.default, value: showDetail)
    }
    
    private let sampleFeatures: [Feature] = [
        Feature(
            imageName: "feature_pre_comp_routine", // Placeholder image name
            title: "Pre-Competition Routine",
            subtitle: "Calm nerves & focus mind: proven steps for peak mental state.", // More engaging subtitle
            detailedContent: """
            Master your race day mindset! This routine covers visualization techniques used by pros to reduce anxiety and enhance focus. Learn simple breathing exercises to stay calm under pressure and key mental cues to activate your competitive edge right before the start. Includes a checklist for your final hour preparation.
            """,
            imagePrompt: "Cinematic photo, close-up on an athlete's determined eyes reflecting a starting line, minutes before a competition, focused intensity, soft background blur of a stadium track, dramatic lighting, high detail. Style: Realistic Photography."
        ),
        Feature(
            imageName: "feature_recovery_essentials", // Placeholder image name
            title: "Recovery Essentials",
            subtitle: "Faster muscle repair & reduced soreness: key stretches & nutrition.", // More engaging subtitle
            detailedContent: """
            Unlock faster recovery! Discover the top 5 dynamic stretches to perform post-workout to improve flexibility and reduce muscle tightness. Learn about the optimal protein and carbohydrate intake timing and sources to refuel your body effectively. Plus, explore the benefits of foam rolling and contrast showers for minimizing soreness.
            """,
            imagePrompt: "Flat lay photo composition of essential post-workout recovery items: foam roller, resistance band, protein shake in a shaker bottle, a bowl of colorful berries and nuts, athletic shoes slightly used. Clean, bright lighting, top-down view. Style: Lifestyle Photography."
        ),
        Feature(
            imageName: "feature_hydration_strategy", // Placeholder image name
            title: "Hydration Strategy",
            subtitle: "Stay energized & avoid cramps: optimal fluid intake guide.", // More engaging subtitle
            detailedContent: """
            Don't let dehydration sabotage your performance! Understand how much water you really need based on workout intensity and duration. Learn to recognize early signs of dehydration and discover the role of electrolytes. Includes practical tips for hydrating before, during, and after your training sessions, plus simple DIY electrolyte drink recipes.
            """,
            imagePrompt: "Action shot of an athlete mid-run on a sunny trail, reaching for a hydration pack or water bottle, splash of water visible, beads of sweat on forehead, focused expression. Dynamic angle, natural light. Style: Sports Photography."
        ),
        // Add more features if needed
        Feature(
            imageName: "feature_sleep_performance",
            title: "Sleep for Performance",
            subtitle: "The overlooked recovery tool: optimize sleep for faster gains.",
            detailedContent: """
            Sleep is your secret weapon! Learn how crucial quality sleep is for muscle growth, hormone regulation, and mental recovery. Discover practical tips to improve your sleep hygiene, create a sleep-promoting bedroom environment, and understand how sleep cycles impact your energy levels. Includes a guide to power naps.
            """,
            imagePrompt: "Split image: left side shows a dimly lit, calm bedroom with a comfortable bed; right side shows a vibrant athlete crossing a finish line looking energized. Soft transition between the two halves. Style: Conceptual Photography."
           ),
        Feature(
            imageName: "feature_mindful_training",
            title: "Mindful Training",
            subtitle: "Connect body & mind: enhance focus and prevent burnout.",
            detailedContent: """
            Train smarter, not just harder. Explore mindfulness techniques to bring full awareness to your workouts. Learn how focusing on breath and body sensations can improve form, prevent injuries, and make training more enjoyable. Discover strategies to manage workout boredom and stay motivated long-term.
            """,
            imagePrompt: "Serene image of a person meditating or doing yoga outdoors (park or mountain view), eyes closed, calm expression, soft morning light filtering through trees or clouds. Focus on the person's peaceful state amidst nature. Style: Wellness Photography."
           ),
        Feature(
            imageName: "tip_marathon_fuel",
            title: "Marathon Fueling",
            subtitle: "Master nutrition before, during, & after to conquer the distance.",
            detailedContent: """
            Fuel your marathon success! Learn exactly what to eat the night before and morning of your long run for sustained energy (complex carbs, moderate protein). Discover effective strategies for fueling *during* the run: energy gels, chews, or real food options, and how often to take them based on duration. Master post-run recovery nutrition to replenish glycogen stores and repair muscle (protein + carbs within the crucial 1-2 hour window). Hydration is key - tips included!
            """,
            imagePrompt: "Serene image of a person meditating or doing yoga outdoors (park or mountain view), eyes closed, calm expression, soft morning light filtering through trees or clouds. Focus on the person's peaceful state amidst nature. Style: Wellness Photography."
        ),
        Feature(
            imageName: "tip_core_plank",
            title: "Core Stability Essentials",
            subtitle: "Build injury resistance & power transfer with fundamental core exercises.",
            detailedContent: """
            Build a foundation of steel! Understand why a stable core is crucial for injury prevention and transferring power in *all* sports. This guide details key stability exercises beyond basic crunches: master the perfect plank (and variations like side planks), learn anti-rotation movements like the Pallof press, and incorporate loaded carries (e.g., farmer's walks) to challenge your core in functional ways. Includes progression tips for all levels.
            """,
            imagePrompt: ""
           ),
        Feature(
            imageName: "tip_sprint_start",
            title: "Sprint Training Secrets",
            subtitle: "Explode off the line & maintain top speed with pro techniques.",
            detailedContent: """
            Unlock explosive speed! This guide covers the critical phases of sprinting: optimizing your block start for maximum acceleration, refining stride length and frequency for top speed maintenance, and specific drills (like resisted sprints and plyometrics) to build raw power. Learn common mistakes and how to correct them for faster times. Includes tips on race day mental prep.
            """,
            imagePrompt: ""
           ),
        Feature(
                imageName: "tip_athlete_meal_prep",
                title: "Nutrition Guide for Athletes",
                subtitle: "Timing is everything: optimize pre & post workout meals for results.",
                detailedContent: """
                Optimize your workouts with smart nutrition timing! This guide explains the 'anabolic window' myth and reality. Learn ideal pre-workout meals (1-3 hours before) focusing on digestible carbs for energy without stomach upset. Discover post-workout essentials (within 1-2 hours) combining quality protein for muscle repair and complex carbs for glycogen replenishment. Includes sample meal ideas for strength vs. endurance training.
                """,
                imagePrompt: "Photo of a well-organized meal prep container showing a balanced athlete's meal: grilled chicken breast or tofu, quinoa or sweet potato, and steamed broccoli/peppers. Top-down view, clean presentation. Style: Food Photography."
            ),
            Feature(
                imageName: "tip_foam_rolling",
                title: "Recovery Techniques",
                subtitle: "Speed up recovery & prevent overtraining with these key methods.",
                detailedContent: """
                Recovery is where gains happen! Explore techniques beyond just rest days. Learn the benefits of active recovery (like light cycling or swimming) to reduce muscle soreness, the crucial role of quality sleep (aim for 7-9 hours), basic foam rolling and massage gun techniques to release muscle tightness (myofascial release), and simple stress management practices (like meditation) that significantly impact physical recovery.
                """,
                imagePrompt: "Photo of an athlete using a foam roller or massage gun on their leg muscles after a workout, focused but relaxed expression, comfortable athletic wear, in a bright gym or home fitness area. Style: Fitness/Wellness Photography."
            ),
            Feature(
                imageName: "tip_leg_squat",
                title: "Building Leg Strength",
                subtitle: "Master compound lifts like squats & deadlifts for a powerful base.",
                detailedContent: """
                Develop powerful legs for improved performance and injury resilience across all activities. This guide focuses on mastering fundamental compound movements: Squats (Back, Front, Goblet), Deadlifts (Conventional, Romanian), and Lunges (Forward, Reverse, Lateral). Learn the critical importance of proper form for safety and maximizing muscle activation. Understand progressive overload principles to apply for continuous strength gains.
                """,
                imagePrompt: "Side profile action shot of an athlete performing a barbell back squat or deadlift with excellent form in a well-equipped gym, emphasizing leg and glute muscles under tension. Strong, focused lighting. Style: Fitness Photography."
            ),
            Feature(
                imageName: "tip_running_form",
                title: "Improving Running Form",
                subtitle: "Run smoother, faster, & reduce injury risk with simple technique cues.",
                detailedContent: """
                Run smoother, faster, and with fewer injuries! Learn key elements of efficient running form by focusing on actionable cues: maintaining an upright posture ('run tall'), optimizing your foot strike (aiming for midfoot landing under your center of gravity), increasing cadence slightly (more steps per minute, often around 170-180), and using a relaxed, compact arm swing. Includes simple drills like 'butt kicks' and 'high knees' to incorporate into warm-ups.
                """,
                imagePrompt: "Side view photo of a runner mid-stride on a scenic outdoor path or track, demonstrating good running form: upright posture, relaxed shoulders, mid-foot strike occurring under the hip, fluid motion. Natural lighting, slightly blurred background suggesting movement. Style: Sports Photography."
            )
    ]
}

//MARK: - Tip Card View (Modified for Matched Geometry)
struct TipCardView: View {
    let feature: Feature // Use Feature model
    let secondaryTextColor: Color
    let namespace: Namespace.ID // Receive namespace

    var body: some View {
        VStack(alignment: .leading) {
            // Placeholder for Image - Match ID for animation
//            Rectangle()
//                .fill(Color.gray.opacity(0.5))
//                .frame(height: 120)
//                .overlay(Image(systemName: "photo").resizable().scaledToFit().frame(width: 50, height: 50).foregroundColor(.white.opacity(0.7)))
            Image(feature.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 120)
                .clipped()
                // ---> Matched Geometry ID for Image <---
                .matchedGeometryEffect(id: "\(feature.id)_image", in: namespace)

            VStack(alignment: .leading, spacing: 4) {
                Text(feature.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                     // ---> Matched Geometry ID for Title <---
                     .matchedGeometryEffect(id: "\(feature.id)_title", in: namespace)
                Text(feature.subtitle)
                    .font(.caption)
                    .foregroundColor(secondaryTextColor)
                    .lineLimit(2)
                     // ---> Matched Geometry ID for Subtitle <---
                     .matchedGeometryEffect(id: "\(feature.id)_subtitle", in: namespace)
            }
            .padding([.horizontal, .bottom])
            .padding(.top, 5)
        }
        .background(Color.black.opacity(0.4))
        .cornerRadius(12)
        .frame(width: 200)
         // ---> Matched Geometry ID for Card Background <---
         // Apply to the background *modifier* not the VStack directly for better results
         .background(
              RoundedRectangle(cornerRadius: 12)
                  .fill(Color.black.opacity(0.4)) // Match the actual background
                  .matchedGeometryEffect(id: "\(feature.id)_card", in: namespace)
         )
    }
}


struct FeatureDetailView: View {
    let feature: Feature
    @Binding var showDetail: Bool // Binding to control visibility
    let namespace: Namespace.ID // Receive namespace

    //MARK: - Colors
    // Use specific colors or inherit if needed
    private let detailBackgroundColor = Color(red: 34/255, green: 34/255, blue: 34/255) // Match main background
    private let secondaryTextColor = Color.gray

    var body: some View {
        ScrollView { // Make content scrollable
            VStack(alignment: .leading, spacing: 0) { // Use spacing 0 for seamless image/text
                //MARK: - Image Placeholder
                Image(feature.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size().width, height: 250)
                    .clipped()
                     // ---> Matched Geometry ID for Image <---
                     .matchedGeometryEffect(id: "\(feature.id)_image", in: namespace)
                     // Add top safe area inset if not using NavigationView bar
                     .ignoresSafeArea(edges: .top)


                //MARK: - Text Content Area
                VStack(alignment: .leading, spacing: 15) {
                    Text(feature.title)
                        .font(.title) // Larger title
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                         // ---> Matched Geometry ID for Title <---
                       //  .matchedGeometryEffect(id: "\(feature.id)_title", in: namespace)

                    Text(feature.subtitle) // Display subtitle again for context if needed
                         .font(.callout)
                         .foregroundColor(secondaryTextColor)
                         // ---> Matched Geometry ID for Subtitle <---
                       //  .matchedGeometryEffect(id: "\(feature.id)_subtitle", in: namespace)

                    // Divider or spacing
                    Rectangle()
                         .fill(Color.gray.opacity(0.3))
                         .frame(height: 1)
                         .padding(.vertical, 10)

                    // Detailed Content
                    Text(feature.detailedContent)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.85))
                        .lineSpacing(5) // Improve readability

                    Spacer() // Push content up if scroll view has extra space

                }
                .padding() // Add padding around the text content
                .padding(.bottom, 60) // Add padding at the bottom to avoid close button overlap

            } // End Main VStack
        } // End ScrollView
        // Apply background to the ScrollView content if needed, or ZStack behind it
         .background(detailBackgroundColor.ignoresSafeArea())
         // ---> Matched Geometry ID for Card Background <---
         // Apply to the background of the main container for smooth transition
         .background(
              Rectangle()
                  .fill(detailBackgroundColor) // Match the detail background color
                  .matchedGeometryEffect(id: "\(feature.id)_card", in: namespace)
                  .ignoresSafeArea() // Ensure background covers whole area
         )
        .overlay(alignment: .topTrailing) {
             //MARK: - Close Button
            VStack {
                Button {
                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                        showDetail = false // Dismiss the detail view
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2.weight(.medium))
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                }
                .padding()
                
                Spacer()
            }// Add padding to the button itself
            // .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) // Adjust for safe area
        }
         .preferredColorScheme(.dark)
         .statusBar(hidden: true) // Optionally hide status bar in detail view
    }
}
