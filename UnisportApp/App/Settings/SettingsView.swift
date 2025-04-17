//
//  SettingsView.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//

import SwiftUI
import StoreKit


struct SettingsView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var isPresented: Bool // To dismiss the cover
    @ObservedObject var viewModel: ProfileViewModel
    let userName: String = "Name"
    let userEmail: String = "mail"
    
    @State private var pushNotificationsEnabled = true // Example state
    @State private var isShareSheetShowing = false
    @State private var isWannaDelete = false

    
    private let appStoreID = "6744744592"
    private var appStoreURL: URL? {
        URL(string: "https://apps.apple.com/app/id\(appStoreID)")
    }
    private let shareText = "Check out this cool app for sport tracking!"
    
    //MARK: - Colors & Data
    private let backgroundColor = Color(red: 34/255, green: 34/255, blue: 34/255)
    private let cardBackgroundColor = Color.black.opacity(0.25)
    private let accentColor = Color(red: 0.22, green: 0.85, blue: 0.32) // #38d951
    private let secondaryTextColor = Color.gray
    
    private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    
    
    var body: some View {
        NavigationView { // Navigation view for title and back button
            ScrollView {
                VStack(spacing: 20) {
                    //MARK: - User Info Header (Simplified)
                    HStack(spacing: 15) {
                        (viewModel.avatarImage ?? Image(systemName: "person.crop.circle.fill")) // Use loaded image or placeholder
                            .resizable()
                            .aspectRatio(contentMode: .fill) // Fill circle
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .background( // Background for placeholder
                                Circle().fill(Color.gray.opacity(0.5))
                            )
                            .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1)) 
                        
                        VStack(alignment: .leading) {
                            Text(authViewModel.currentuser?.name ?? "Anonymous")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text(authViewModel.userSession?.email ?? "")
                                .font(.caption)
                                .foregroundColor(secondaryTextColor)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 10) // Add space from nav bar
                    
                    
                    //MARK: - Settings Items
                    VStack(spacing: 10) {
                        //                         SettingsToggleRow(
                        //                             icon: "bell.fill",
                        //                             title: "Push Notifications",
                        //                             isOn: $pushNotificationsEnabled,
                        //                             backgroundColor: cardBackgroundColor,
                        //                             accentColor: accentColor
                        //                         )
                        
                        SettingsNavigationRow(icon: "message.fill", title: "Feedback", backgroundColor: cardBackgroundColor) { openTerms(stringURL: "https://sites.google.com/view/unisportpro/contact-us") }
                        SettingsNavigationRow(icon: "info.circle.fill", title: "About the App", backgroundColor: cardBackgroundColor) { openTerms(stringURL: "https://sites.google.com/view/unisportpro/about-us") }
                        SettingsNavigationRow(icon: "star.fill", title: "Rate the App", backgroundColor: cardBackgroundColor) { rateAction() }
                        SettingsNavigationRow(icon: "square.and.arrow.up.fill", title: "Share App", backgroundColor: cardBackgroundColor) { shareAction() }
                        SettingsNavigationRow(icon: "shield.lefthalf.filled", title: "Privacy Policy", backgroundColor: cardBackgroundColor) { openTerms(stringURL: "https://sites.google.com/view/unisportpro/privacy-policy") }
                        SettingsNavigationRow(icon: "doc.text.fill", title: "User Agreement", backgroundColor: cardBackgroundColor) { openTerms(stringURL: "https://sites.google.com/view/unisportpro/terms-of-use") }
                        SettingsNavigationRow(icon: "door.left.hand.closed", title: "Log Out", backgroundColor: cardBackgroundColor) { authViewModel.signOut() }
                        SettingsNavigationRow(icon: "trash.fill", title: "Delete Account", backgroundColor: cardBackgroundColor) { isWannaDelete.toggle() }
                    }
                    .padding(.horizontal)
                    
                    
                    Spacer() // Pushes version text down
                    
                }
            }
            .safeAreaInset(edge: .bottom) {
                //MARK: - App Version Footer
                Text("App Version: \(appVersion)")
                    .font(.caption)
                    .foregroundColor(secondaryTextColor)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(backgroundColor) // Match background
            }
            .background(backgroundColor.ignoresSafeArea())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isPresented = false // Dismiss action for the cover
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $isShareSheetShowing) {
            if let url = appStoreURL {
                ShareSheet(activityItems: [shareText, url])
            } else {
                Text("Error generating share link.")
            }
        }
        .alert("Are you sure?", isPresented: $isWannaDelete) {
            Button {
                authViewModel.deleteUserAccount { result in
                    switch result {
                    case .success():
                        print("Account deleted successfully.")
                        authViewModel.userSession = nil
                        authViewModel.currentuser = nil
                    case .failure(let error):
                        print("ERROR DELELETING: \(error.localizedDescription)")
                    }
                }
            } label: {
                Text("Yes")
            }
            
            Button {
                
            } label: {
                Text("No")
            }
        } message: {
            Text("")
        }
    }
    
    func openTerms(stringURL: String) {
        if let url = URL(string: stringURL) {
            UIApplication.shared.open(url)
        }
    }
    
    func rateAction() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    func shareAction() {
        if appStoreURL != nil {
            isShareSheetShowing = true
        } else {
            print("Error: App Store URL is not configured correctly. Replace YOUR_APP_ID.")
        }
    }
}

//MARK: - Settings Subviews

struct SettingsToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    let backgroundColor: Color
    let accentColor: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(accentColor)
                .frame(width: 25) // Align icons
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.white)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(accentColor) // Color the toggle
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(10)
    }
}

struct SettingsNavigationRow: View {
    let icon: String
    let title: String
    let backgroundColor: Color
    let action: () -> Void // Placeholder for navigation or action
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(Color.green) // Using default green here, adjust if needed
                    .frame(width: 25) // Align icons
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(backgroundColor)
            .cornerRadius(10)
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isPresented: .constant(true), viewModel: ProfileViewModel())
            .preferredColorScheme(.dark)
            .environmentObject(AuthViewModel())
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil // Можно добавить кастомные действия, если нужно
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil // Можно исключить системные действия
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        controller.excludedActivityTypes = excludedActivityTypes
        // controller.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
        //     // Здесь можно добавить код, который выполнится после закрытия листа
        //     print("Share sheet completed: \(completed), activity: \(activityType?.rawValue ?? "none")")
        // }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Обычно оставляем пустым для этого случая
    }
}
