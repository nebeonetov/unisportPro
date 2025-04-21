//
//  MotivationOnboardingView.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//

import SwiftUI

struct MotivationOnboardingView: View {
    @Binding var isPresented: Bool // To dismiss the sheet
    @AppStorage("hasCompletedMotivationOnboarding") var hasCompletedOnboarding: Bool = false

    @State private var selectedPageIndex = 0
    private let pages = MotivationData.onboardingPages

    //MARK: - Colors
    private let backgroundColor = Color(red: 34/255, green: 34/255, blue: 34/255)
    private let accentColor = Color(red: 0.22, green: 0.85, blue: 0.32) // #38d951

    var body: some View {
        VStack {
            //MARK: - Header (Skip Button)
            HStack {
                Spacer()
                Button("Skip") {
                    completeOnboarding()
                }
                .foregroundColor(.gray)
                .padding()
            }

            //MARK: - TabView for Pages
            TabView(selection: $selectedPageIndex) {
                ForEach(pages.indices, id: \.self) { index in
                    OnboardingPageView(page: pages[index], accentColor: accentColor)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never)) // Hide default page control


            //MARK: - Custom Page Control
            HStack(spacing: 8) {
                ForEach(pages.indices, id: \.self) { index in
                    Circle()
                        .fill(selectedPageIndex == index ? accentColor : .gray.opacity(0.5))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.bottom, 20)


            //MARK: - Action Button
            Button {
                if selectedPageIndex == pages.count - 1 {
                    // Last page action
                    completeOnboarding()
                } else {
                    // Next page action
                    withAnimation {
                        selectedPageIndex += 1
                    }
                }
            } label: {
                Text(selectedPageIndex == pages.count - 1 ? "Share Motivation" : "Next")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(accentColor)
                    .cornerRadius(12)
            }
            // Use dynamic label based on screenshot (needs adjustment)
            // Label(selectedPageIndex == pages.count - 1 ? "Start" : (selectedPageIndex == 0 ? "Next" : "How to send"), systemImage: "")

            .padding(.horizontal, 25)
            .padding(.bottom, 40)

        }
        .background(backgroundColor.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }

    private func completeOnboarding() {
        hasCompletedOnboarding = true
        isPresented = false // Dismiss the sheet
    }
}

//MARK: - Single Onboarding Page View
struct OnboardingPageView: View {
    let page: OnboardingPageData
    let accentColor: Color

    var body: some View {
        VStack(spacing: 30) {
            Spacer() // Push content down slightly

            // Icon
            Image(systemName: page.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.white)
                .padding(30)
                .background(accentColor.opacity(0.8))
                .clipShape(Circle())

            // Texts
            VStack(spacing: 15) {
                Text(page.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text(page.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40) // Add horizontal padding to text

            Spacer() // Push towards center
            Spacer() // Add more space at bottom before page control/button
        }
    }
}
