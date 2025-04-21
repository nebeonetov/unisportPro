//
//  MotivationFeedView.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//


import SwiftUI

struct MotivationFeedView: View {
    @State private var showOnboarding = false
    @State private var showShareSheet = false
    @AppStorage("hasCompletedMotivationOnboarding") var hasCompletedOnboarding: Bool = false

    private let quotes = MotivationData.motivationalQuotes

    //MARK: - Colors
    private let backgroundColor = Color(red: 34/255, green: 34/255, blue: 34/255)
    private let cardBackgroundColor = Color.black.opacity(0.25)
    private let accentColor = Color(red: 0.22, green: 0.85, blue: 0.32) // #38d951
    private let secondaryTextColor = Color.gray

    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    HStack(spacing: 10) { // Add spacing
                        Text("Motivation")
                            .font(.largeTitle).fontWeight(.bold).foregroundColor(.white)


                        Button {
                            showOnboarding = true // Trigger onboarding manually
                        } label: {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.title3) // Adjust size
                                .foregroundColor(secondaryTextColor)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        showShareSheet = true // Show share sheet
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(accentColor)
                    }
                }
                .padding(.horizontal).padding(.top)
                
                LazyVStack(spacing: 15) {
                    ForEach(quotes) { quote in
                        QuoteCardView(
                            quote: quote,
                            backgroundColor: cardBackgroundColor,
                            secondaryTextColor: secondaryTextColor,
                            accentColor: accentColor
                        )
                        // Add navigation link if needed for detail view
                    }
                }
                .padding() // Padding around the LazyVStack
            }
            .background(backgroundColor.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline) // Keep title inline
          
            .fullScreenCover(isPresented: $showOnboarding) {
                MotivationOnboardingView(isPresented: $showOnboarding)
                    .onDisappear {
                        showShareSheet.toggle()
                    }
            }
             .sheet(isPresented: $showShareSheet) {
                ShareMotivationView(isPresented: $showShareSheet)
             }
            .onAppear {
                 // Show onboarding automatically only if not completed
                 if !hasCompletedOnboarding {
                     // Use a short delay to ensure the view is fully loaded before presenting cover
                     DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                          showOnboarding = true
                     }
                 }
            }
             .preferredColorScheme(.dark)
        }
        .navigationViewStyle(.stack) // Consistent navigation style
    }
}


//MARK: - Quote Card View
struct QuoteCardView: View {
    let quote: MotivationalQuote
    let backgroundColor: Color
    let secondaryTextColor: Color
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            //MARK: - Author Info
            HStack {
                Image(systemName: quote.avatarPlaceholder)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white.opacity(0.8))
                    .background(Color.gray.opacity(0.5))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(quote.authorName)
                        .font(.subheadline) // Smaller font for author
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    Text(quote.timestamp)
                        .font(.caption)
                        .foregroundColor(secondaryTextColor)
                }
                Spacer()
            }

            //MARK: - Quote Text
            Text(quote.text)
                .font(.body) // Standard body font for quote
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(5) // Add some line spacing for readability

          
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(15)
    }
}


//MARK: - Previews Block

struct MotivationFeedView_Previews: PreviewProvider {
    static var previews: some View {
        // Preview within a TabView context if possible
         TabView {
             MotivationFeedView()
                 .tabItem {
                     Label("Motivation", systemImage: "flame")
                 }
         }
        .preferredColorScheme(.dark)
    }
}

//struct MotivationOnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        MotivationOnboardingView(isPresented: .constant(true))
//            .preferredColorScheme(.dark)
//    }
//}
//
//struct ShareMotivationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShareMotivationView(isPresented: .constant(true))
//            .preferredColorScheme(.dark)
//    }
//}

// Preview for the overlay
struct SubmissionStatusOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SubmissionStatusOverlayView(submissionState: .constant(.submitting))
            SubmissionStatusOverlayView(submissionState: .constant(.success))
            SubmissionStatusOverlayView(submissionState: .constant(.error("Network failed")))
        }
        .background(Color.blue.opacity(0.3)) // Add background to see overlay bounds
        .previewLayout(.sizeThatFits)
    }
}
