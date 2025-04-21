//
//  MainTabView.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//

import SwiftUI


//MARK: - Main Tab Container
struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab: Tab = .tracker

    //MARK: - Colors
    private let backgroundColor = Color(red: 34/255, green: 34/255, blue: 34/255)

    init() {
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            backgroundColor.ignoresSafeArea()

            VStack(spacing: 0) {
                // Content Area
                switch selectedTab {
                case .tracker:
                    TrackerView()
                case .tips:
                    MiniGamesView()
                case .plans:
                    PlansView()
                case .motivation:
                    MotivationFeedView()
                case .profile:
                     ProfileView()
                        .environmentObject(authViewModel)
                }

                // Custom TabBar pushes content up
                Spacer(minLength: 80) // Adjust minLength to match TabBar height
            }


            // Custom TabBar overlay
            CustomTabBar(selectedTab: $selectedTab)
        }
        .preferredColorScheme(.dark)
    }
}

//MARK: - Tab Enum
enum Tab: String, CaseIterable {
    case tracker = "Tracker"
    case tips = "Relax"
    case plans = "Plans"
    case motivation = "Motivation"
    case profile = "Profile"

    var iconName: String {
        switch self {
        case .tracker: return "chart.bar"
        case .tips: return "trophy"
        case .plans: return "flag"
        case .motivation: return "flame"
        case .profile: return "person"
        }
    }
}

//MARK: - Custom Tab Bar View
struct CustomTabBar: View {
    @Binding var selectedTab: Tab

    //MARK: - Colors
    private let tabBarBackgroundColor = Color.black.opacity(0.8)
    private let accentColor = Color(red: 0.22, green: 0.85, blue: 0.32) // #38d951
    private let inactiveColor = Color.gray

    var body: some View {
        HStack {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                Spacer()
                VStack(spacing: 4) {
                    Image(systemName: selectedTab == tab ? tab.iconName + ".fill" : tab.iconName)
                        .font(.system(size: 22))
                        .foregroundColor(selectedTab == tab ? accentColor : inactiveColor)

                    Text(tab.rawValue)
                        .font(.caption)
                        .foregroundColor(selectedTab == tab ? accentColor : inactiveColor)
                }
                .onTapGesture {
                    selectedTab = tab
                }
                Spacer()
            }
        }
        .frame(height: 80) // Adjust height as needed
        .background(tabBarBackgroundColor)
        .shadow(radius: 5)
    }
}






//MARK: - Consistency Index View (Placeholder)
struct ConsistencyIndexView: View {
    let backgroundColor: Color
    let secondaryTextColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Athletic Consistency Index") // Sports Consistency Index
                .font(.headline)
                .foregroundColor(.white)

            Text("Not enough data, keep exercising and using the app.")
                .font(.subheadline)
                .foregroundColor(secondaryTextColor)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity) // Center text
                .padding(.vertical, 10) // Add some vertical padding
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(15)
    }
}











//MARK: - Previews
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(AuthViewModel())
    }
}

//struct TrackerView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrackerView()
//    }
//}
