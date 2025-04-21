//
//  WelcomePageView.swift
//  UnisportApp
//
//  Created by D K on 17.04.2025.
//

import SwiftUI
//MARK: - Welcome Page (Page 0)
struct WelcomePageView: View {
    let page: OnboardingPage
    let accentColor: Color
    @State private var showTitle = false
    @State private var showDesc = false
    @State private var showLogo = false
    @State private var logoRotation: Double = -15

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // Animated Logo (Example)
             HStack {
                 Image(systemName: "bolt.fill") // UniSport Pro Logo element
                     .font(.system(size: 60))
                     .foregroundColor(accentColor)
                 Text("UniSport Pro")
                     .font(.system(size: 35, weight: .bold))
                     .foregroundColor(.white)
             }
             .rotation3DEffect(
                  .degrees(showLogo ? 0 : logoRotation),
                 axis: (x: 0.0, y: 1.0, z: 0.0) // Rotate around Y axis
             )
             .scaleEffect(showLogo ? 1 : 0.8)
             .opacity(showLogo ? 1 : 0)


            VStack(spacing: 15) {
                Text(page.title)
                    .font(.title).fontWeight(.bold).foregroundColor(.white)
                    .opacity(showTitle ? 1 : 0)
                    .offset(y: showTitle ? 0 : 20)
                    .multilineTextAlignment(.center)

                Text(page.description)
                    .font(.headline).foregroundColor(.gray) // Slightly larger desc
                    .multilineTextAlignment(.center)
                    .opacity(showDesc ? 1 : 0)
                    .offset(y: showDesc ? 0 : 20)
            }
            .padding(.horizontal, 40)

            Spacer()
            Spacer()
        }
        .onAppear {
            // Staggered animation triggers
            withAnimation(.interpolatingSpring(stiffness: 50, damping: 10).delay(0.2)) {
                 showLogo = true
                 logoRotation = 0
             }
            withAnimation(.easeOut(duration: 0.6).delay(0.5)) {
                showTitle = true
            }
            withAnimation(.easeOut(duration: 0.6).delay(0.7)) {
                showDesc = true
            }
        }
    }
}

//MARK: - Tracking Page (Page 1)
struct TrackingPageView: View {
    let page: OnboardingPage
    let accentColor: Color
    @State private var filledSquares: Int = 0
    let totalSquares = 7 * 4 // Example: 4 weeks
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 4), count: 7)

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // Animated Activity Board
             LazyVGrid(columns: columns, spacing: 4) {
                 ForEach(0..<totalSquares, id: \.self) { index in
                     RoundedRectangle(cornerRadius: 3)
                          // Fill based on index vs animated count
                          .fill(index < filledSquares ? accentColor : Color.gray.opacity(0.3))
                          .opacity(index < filledSquares ? 1.0 : 0.5) // Make filled stand out
                          .aspectRatio(1.0, contentMode: .fit)
                          .animation(.easeInOut.delay(Double(index) * 0.02), value: filledSquares) // Staggered fill animation
                 }
             }
             .padding(.horizontal, 50) // Constrain width a bit

            VStack(spacing: 15) {
                Text(page.title)
                    .font(.title2).fontWeight(.bold).foregroundColor(.white)
                Text(page.description)
                    .font(.subheadline).foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)

            Spacer()
            Spacer()
        }
        .onAppear {
             // Reset before animating
             filledSquares = 0
             // Animate filling the squares
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Delay start
                 withAnimation(.easeOut(duration: 1.5)) { // Control overall fill speed
                     filledSquares = Int.random(in: 15...totalSquares - 5) // Fill a random amount
                 }
            }
        }
         // Add other text animations like GenericPageView if desired
    }
}


//MARK: - Planning Page (Page 2)
struct PlanningPageView: View {
    let page: OnboardingPage
    let accentColor: Color
    @State private var items: [PlanningItem] = [
         PlanningItem(text: "Register for Marathon", delay: 0.4),
         PlanningItem(text: "Build Base Mileage", delay: 0.6),
         PlanningItem(text: "Start Speed Work", delay: 0.8),
         PlanningItem(text: "Tapering Phase", delay: 1.0),
         PlanningItem(text: "Race Day!", delay: 1.2)
    ]
    @State private var showItems = false

    struct PlanningItem: Identifiable {
        let id = UUID()
        let text: String
        let delay: Double
        var isVisible: Bool = false
        var isChecked: Bool = false
    }

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // Animated Plan List
             VStack(alignment: .leading, spacing: 15) {
                 ForEach($items) { $item in
                     HStack {
                          Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                               .foregroundColor(item.isChecked ? accentColor : .gray)
                               .scaleEffect(item.isVisible ? 1 : 0.5) // Pop in animation
                               .animation(.interpolatingSpring(stiffness: 100, damping: 10).delay(item.delay + 0.3), value: item.isVisible) // Checkmark animation

                          Text(item.text)
                               .font(.callout)
                               .foregroundColor(.white.opacity(0.9))
                               .strikethrough(item.isChecked, color: .gray)
                               .offset(x: item.isVisible ? 0 : -20) // Slide in animation
                               .opacity(item.isVisible ? 1 : 0)
                               .animation(.easeOut(duration: 0.4).delay(item.delay), value: item.isVisible) // Text animation
                     }
                 }
             }
             .padding(30)
             .background(Color.gray.opacity(0.2).cornerRadius(15))
             .padding(.horizontal, 40)


            VStack(spacing: 15) {
                Text(page.title)
                    .font(.title2).fontWeight(.bold).foregroundColor(.white)
                Text(page.description)
                    .font(.subheadline).foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)

            Spacer()
            Spacer()
        }
        .onAppear {
             // Reset state
             showItems = false
             for i in items.indices { items[i].isVisible = false; items[i].isChecked = false }

             // Trigger animations
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                 showItems = true
                 for i in items.indices {
                     items[i].isVisible = true
                      // Animate checkmarks sequentially after text appears
                      if i < items.count - 1 { // Don't check the last item
                           DispatchQueue.main.asyncAfter(deadline: .now() + items[i].delay + 0.8) {
                                withAnimation(.spring()) {
                                     items[i].isChecked = true
                                }
                           }
                      }
                 }
            }
        }
         // Add other text animations like GenericPageView if desired
    }
}


//MARK: - Tips Page (Page 3)
struct TipsPageView: View {
    let page: OnboardingPage
    let accentColor: Color
    @State private var showCards = false
    let cardCount = 3
    let cardWidth: CGFloat = 150
    let cardHeight: CGFloat = 200

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // Animated Cards Stack/Fan
             ZStack {
                 ForEach(0..<cardCount, id: \.self) { index in
                      RoundedRectangle(cornerRadius: 15)
                           .fill(Color.gray.opacity(0.25))
                           .overlay(
                                VStack {
                                     Image(systemName: ["lightbulb.fill", "star.fill", "figure.run"][index % 3]) // Example icons
                                         .font(.largeTitle)
                                         .foregroundColor(accentColor.opacity(0.8))
                                         .padding(.bottom, 5)
                                     Text("Tip \(index + 1)")
                                         .font(.caption)
                                         .foregroundColor(.white.opacity(0.7))
                                }.padding()
                           )
                           .frame(width: cardWidth, height: cardHeight)
                           .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 4)
                            // Animation modifiers
                           .offset(x: showCards ? CGFloat(index - 1) * (cardWidth * 0.6) : 0, // Fan out horizontally
                                    y: showCards ? CGFloat(index) * -8 : 0) // Slight vertical offset
                           .rotationEffect(.degrees(showCards ? Double(index - 1) * 10 : 0)) // Fan out rotation
                           .opacity(showCards ? 1 : 0)
                           .animation(.interpolatingSpring(stiffness: 50, damping: 12).delay(0.3 + Double(index) * 0.1), value: showCards)
                 }
             }
             .frame(height: cardHeight + 40) // Give ZStack enough height

            VStack(spacing: 15) {
                Text(page.title)
                    .font(.title2).fontWeight(.bold).foregroundColor(.white)
                Text(page.description)
                    .font(.subheadline).foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)

            Spacer()
        }
        .onAppear {
             showCards = false // Reset
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                 showCards = true
            }
        }
         // Add other text animations like GenericPageView if desired
    }
}


//MARK: - Motivation Page (Page 4)

struct MotivationPageView: View {
    let page: OnboardingPage
    let accentColor: Color
    @State private var showMessages = false
    // Make messages identifiable if needed for specific animations later
    struct MessageItem: Identifiable {
        let id = UUID()
        let text: String
    }
    let messages: [MessageItem] = [
        MessageItem(text: "Keep Going!"),
        MessageItem(text: "You Got This!"),
        MessageItem(text: "💪"),
        MessageItem(text: "Believe!"),
        MessageItem(text: "Push Harder!"),
        MessageItem(text: "✨"),
        MessageItem(text: "One More Rep!"),
        MessageItem(text: "Stay Strong!")
    ].shuffled() // Shuffle for variety each time

    // Define layout parameters
    let radius: CGFloat = 110 // Radius of the circle/arc
    let angularSpread: Double = 270 // How much of the circle to use (degrees)
    let angleOffset: Double = -135 // Starting angle offset (degrees), -90 is top

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // Animated Message Bubbles - Using GeometryReader
            GeometryReader { geometry in
                ZStack {
                    // Calculate center once
                    let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2 - 30) // Adjust Y offset if needed

                    ForEach(messages.indices, id: \.self) { index in
                        // Calculate angle for each item
                        let angleDegrees = angleOffset + (angularSpread / Double(messages.count - 1)) * Double(index)
                        let angleRadians = angleDegrees * .pi / 180.0

                        // Calculate position on the circle/arc
                        let xPos = center.x + radius * cos(CGFloat(angleRadians))
                        let yPos = center.y + radius * sin(CGFloat(angleRadians))

                        // Add slight random offset for visual interest
                        let randomX = showMessages ? CGFloat.random(in: -10...10) : 0
                        let randomY = showMessages ? CGFloat.random(in: -10...10) : 0

                        Text(messages[index].text)
                            .font(messages[index].text.count > 1 ? .caption : .title)
                            .padding(messages[index].text.count > 1 ? 10 : 15)
                            .foregroundColor(index % 2 == 0 ? .black : .white)
                            .background(index % 2 == 0 ? accentColor : Color.gray.opacity(0.4))
                            .clipShape(Capsule())
                            .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
                            // Animation
                            .scaleEffect(showMessages ? 1 : 0.1) // Start smaller
                            .opacity(showMessages ? 1 : 0)
                            .position(x: xPos + randomX, y: yPos + randomY) // Set calculated position
                             // Use a spring animation with delay
                            .animation(.interpolatingSpring(
                                mass: 0.6, stiffness: 80, damping: 10, initialVelocity: 0
                            ).delay(0.3 + Double(index) * 0.08), value: showMessages) // Staggered delay
                    }
                }
                 // Ensure ZStack takes available space for positioning
                 .frame(maxWidth: .infinity, maxHeight: .infinity)

            }
             // Give the GeometryReader area a fixed height to contain the animation
             .frame(height: 2 * radius + 60) // Diameter + padding


            VStack(spacing: 15) {
                 Text(page.title)
                     .font(.title2).fontWeight(.bold).foregroundColor(.white)
                     .padding(.top) // Add padding if layout is tight
                 Text(page.description)
                     .font(.subheadline).foregroundColor(.gray)
                     .multilineTextAlignment(.center)
            }
            .frame(height: 100)
            .padding(.horizontal, 40)
            // Add simple fade/offset to text as well
            .opacity(showMessages ? 1 : 0)
            .offset(y: showMessages ? 0 : 15)
            .animation(.easeOut(duration: 0.5).delay(0.8), value: showMessages) // Delay text appearance


            Spacer()
        }
        .onAppear {
            showMessages = false // Reset
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                showMessages = true
            }
        }
    }
}

//MARK: - Onboarding Container View Block


struct OnboardingContainerView: View {
    // Use @AppStorage to skip onboarding next time
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @Environment(\.dismiss) var dismiss
    // Or use a Binding if presenting modally:
    // @Binding var showOnboarding: Bool

    @State private var currentPage: Int = 0
    private let pages = OnboardingData.pages

    //MARK: - Colors
    private let backgroundColor = Color(red: 34/255, green: 34/255, blue: 34/255)
    private let accentColor = Color(red: 0.22, green: 0.85, blue: 0.32) // #38d951

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            VStack {
                //MARK: - Top Bar (Skip Button)
                HStack {
                    Spacer()
                    Button("Skip") {
                        dismiss()
                    }
                    .foregroundColor(.gray)
                    .padding()
                    .opacity(currentPage == pages.count - 1 ? 0 : 1) // Hide on last page
                }

                //MARK: - Page Content (TabView)
                TabView(selection: $currentPage) {
                    // Iterate through pages and display the correct view
                    ForEach(pages.indices, id: \.self) { index in
                         getPageContentView(for: index)
                            .tag(index)
                            // Use ID to help reset state when swiping back/forth
                            .id("Page_\(index)")
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never)) // Hide default dots

                //MARK: - Custom Page Control
                HStack(spacing: 8) {
                    ForEach(pages.indices, id: \.self) { index in
                        Capsule()
                            .fill(currentPage == index ? accentColor : Color.gray.opacity(0.5))
                            .frame(width: currentPage == index ? 25 : 8, height: 8) // Active dot is wider
                    }
                }
                .animation(.easeInOut, value: currentPage) // Animate page control change
                .padding(.bottom, 20)

                //MARK: - Bottom Button
                Button {
                    if currentPage == pages.count - 1 {
                        dismiss()
                    } else {
                        withAnimation(.easeInOut) {
                            currentPage += 1
                        }
                    }
                } label: {
                    Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(accentColor)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 40)
            }
        }
        .preferredColorScheme(.dark)
        // Smooth transition if presented modally
        // .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    // Function to dismiss/complete onboarding
    private func completeOnboarding() {
        print("Onboarding Completed")
        hasCompletedOnboarding = true
        // If using Binding:
        // showOnboarding = false
    }

    // Helper to return the correct view for each page index
    @ViewBuilder
    private func getPageContentView(for index: Int) -> some View {
         let pageData = pages[index]
         // Use index to determine which custom animated view to show
         switch index {
         case 0: // Welcome
              WelcomePageView(page: pageData, accentColor: accentColor)
         case 1: // Tracking
              TrackingPageView(page: pageData, accentColor: accentColor)
         case 2: // Planning
              PlanningPageView(page: pageData, accentColor: accentColor)
         case 3: // Tips
              TipsPageView(page: pageData, accentColor: accentColor)
         case 4: // Motivation
              MotivationPageView(page: pageData, accentColor: accentColor)
         // --- NEW CASE FOR PERSONALIZATION ---
         case 5: // Personalization (Index is now 5)
              PersonalizationPageView(page: pageData, accentColor: accentColor)
         // --- ADJUSTED CASE FOR FINAL PAGE ---
         case 6: // Last Page / Ready to Start? (Index is now 6)
              GenericPageView(page: pageData, accentColor: accentColor)
         default: // Fallback (shouldn't happen with correct indices)
              GenericPageView(page: pageData, accentColor: accentColor)
         }
    }
}


//MARK: - Generic Page View (for simple pages like the last one)
struct GenericPageView: View {
    let page: OnboardingPage
    let accentColor: Color
    @State private var appear = false

    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            if let imageName = page.imageName {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(accentColor)
                    .padding(30)
                    .background(Color.gray.opacity(0.2).clipShape(Circle()))
                    .scaleEffect(appear ? 1 : 0.8)
                    .opacity(appear ? 1 : 0)
            }

            VStack(spacing: 15) {
                Text(page.title)
                    .font(.title2).fontWeight(.bold).foregroundColor(.white)
                    .opacity(appear ? 1 : 0)
                    .offset(y: appear ? 0 : 10)
                Text(page.description)
                    .font(.subheadline).foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .opacity(appear ? 1 : 0)
                    .offset(y: appear ? 0 : 10)
                    .animation(.easeInOut.delay(0.1), value: appear)
            }
            .padding(.horizontal, 40)

            Spacer()
            Spacer()
        }
        .onAppear {
             withAnimation(.interpolatingSpring(stiffness: 50, damping: 10).delay(0.2)) {
                 appear = true
            }
        }
    }
}

//MARK: - Onboarding Data Block


struct OnboardingPage: Identifiable {
    let id = UUID()
    let imageName: String? // SF Symbol name (optional)
    let title: String
    let description: String
    // Optional: Custom view builder for complex pages/animations
    // let customView: AnyView? = nil
}

struct OnboardingData {
    static let pages: [OnboardingPage] = [
        OnboardingPage(
            imageName: nil, // Custom animation instead
            title: "Welcome to UniSport Pro!",
            description: "Track your progress, plan your goals, get inspired, and achieve more together."
        ),
        OnboardingPage(
            imageName: nil, // Custom animation instead
            title: "Visualize Your Consistency",
            description: "Mark workouts daily and watch your activity board light up. Build your streak!"
        ),
        OnboardingPage(
            imageName: nil, // Custom animation instead
            title: "Plan Your Path to Victory",
            description: "Set competition goals and map out your training schedule day by day."
        ),
        OnboardingPage(
            imageName: nil, // Custom animation instead
            title: "Expert Tips & Insights",
            description: "Get motivated and learn from the best with curated advice from experienced athletes."
        ),
        OnboardingPage(
            imageName: nil, // Custom animation instead
            title: "Share & Receive Motivation",
            description: "Connect with the community, share your journey, and lift each other up."
        ),
        OnboardingPage(
                   imageName: nil, // Using custom view, no simple icon needed here
                   title: "Tell Us About Yourself", // Title for the page
                   description: "Personalize your experience for better recommendations." // Optional description
               ),
        OnboardingPage(
            imageName: "figure.run", // Final simple icon
            title: "Ready to Start?",
            description: "Your ultimate fitness companion awaits. Let's crush those goals!"
        )
    ]
}


//MARK: - Preview Block
// Onboarding_Previews.swift

struct OnboardingContainerView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingContainerView()
    }
}

// Optional: Preview individual pages
struct TrackingPageView_Previews: PreviewProvider {
     static var previews: some View {
          TrackingPageView(page: OnboardingData.pages[1], accentColor: .green)
               .frame(maxWidth:.infinity, maxHeight: .infinity)
               .background(Color(red: 34/255, green: 34/255, blue: 34/255))
               .preferredColorScheme(.dark)
     }
}

struct PlanningPageView_Previews: PreviewProvider {
     static var previews: some View {
         PlanningPageView(page: OnboardingData.pages[2], accentColor: .green)
              .frame(maxWidth:.infinity, maxHeight: .infinity)
              .background(Color(red: 34/255, green: 34/255, blue: 34/255))
              .preferredColorScheme(.dark)
     }
}

