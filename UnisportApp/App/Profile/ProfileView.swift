//
//  ProfileView.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//

//
//  ProfileView.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//

//MARK: - Profile View Block (Updated with ViewModel & Image Picker)
// ProfileView.swift

import SwiftUI

struct ProfileView: View {
    
    // ---> Use the ViewModel <---
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = ProfileViewModel()
    
    @State private var showingSettings = false
    @State private var showingActionSheet = false // For choosing camera/gallery
    
    //MARK: - Colors
    private let backgroundColor = Color(red: 34/255, green: 34/255, blue: 34/255)
    private let cardBackgroundColor = Color.black.opacity(0.25)
    private let accentColor = Color(red: 0.22, green: 0.85, blue: 0.32)
    private let secondaryTextColor = Color.gray
    
    // Grid layout definition (remains the same)
    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 15), count: 2)
    
    // Computed array for stats from ViewModel
    private var stats: [StatItem] {
        [
            StatItem(icon: "figure.strengthtraining.traditional", title: "Total Trainings", value: "\(viewModel.totalTrainings)"),
            StatItem(icon: "flame.fill", title: "Current Stream", value: "\(viewModel.currentStreak) days"),
            StatItem(icon: "trophy.fill", title: "Max Stream", value: "\(viewModel.maxStreak) days"),
            StatItem(icon: "envelope.fill", title: "Motivations", value: "\(viewModel.motivationsSent)"),
        ]
    }
    private var competitionsCompleted: StatItem {
        StatItem(icon: "flag.checkered.2.crossed", title: "Competitions Completed", value: "\(viewModel.competitionsCompleted)")
    }
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    //MARK: - User Info Section
                    VStack(spacing: 10) {
                        // ---> Updated AvatarView Call <---
                        AvatarView(
                            image: viewModel.avatarImage, // Pass the image from ViewModel
                            accentColor: accentColor
                        )
                        .padding(.top, 20)
                        // ---> Add tap gesture to show action sheet <---
                        .onTapGesture {
                            showingActionSheet = true
                        }
                        
                        Text(authViewModel.currentuser?.name ?? "Anonymous")
                            .font(.title2).fontWeight(.bold).foregroundColor(.white)

                        Text(authViewModel.userSession?.email ?? "")
                            .font(.subheadline).foregroundColor(secondaryTextColor)

                    }
                    
                    //MARK: - Statistics Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Statistics & Achievements")
                            .font(.title3).fontWeight(.bold).foregroundColor(.white)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(stats) { stat in // Use computed stats
                                StatCardView(item: stat, backgroundColor: cardBackgroundColor)
                            }
                        }
                        .padding(.horizontal)
                        
                        StatCardView(item: competitionsCompleted, backgroundColor: cardBackgroundColor, isWide: true) // Use computed stat
                            .padding(.horizontal)
                    }
                    
                    //MARK: - Settings Button
                    Button { showingSettings = true } label: {
                        Label("Settings", systemImage: "gearshape.fill")
                        /* ... styling ... */
                            .font(.headline).fontWeight(.semibold).foregroundColor(.white)
                            .frame(maxWidth: .infinity).padding().background(cardBackgroundColor).cornerRadius(12)
                    }
                    .padding(.horizontal).padding(.bottom, 20)
                }
            }
            .background(backgroundColor.ignoresSafeArea())
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $showingSettings) {
                SettingsView(isPresented: $showingSettings, viewModel: viewModel)
                    .environmentObject(authViewModel)
            }
            // ---> Action Sheet for Image Source <---
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Choose Photo Source"), buttons: [
                    .default(Text("Camera")) {
                        viewModel.presentImagePicker(sourceType: .camera)
                    },
                    .default(Text("Photo Library")) {
                        viewModel.presentImagePicker(sourceType: .photoLibrary)
                    },
                    .cancel()
                ])
            }
            // ---> Sheet for Image Picker <---
            .sheet(isPresented: $viewModel.showingImagePicker) {
                ImagePicker(
                    sourceType: viewModel.imagePickerSourceType,
                    selectedImage: { uiImage in
                        // Callback when image is selected
                        viewModel.saveAvatarImage(uiImage)
                    }
                )
                // Optional: Ignore safe area if picker needs full screen
                // .ignoresSafeArea()
            }
            .preferredColorScheme(.dark)
        }
        .navigationViewStyle(.stack)
    }
}


//MARK: - AvatarView (Modified to accept Image)
struct AvatarView: View {
    let image: Image? // Optional Image from ViewModel
    let accentColor: Color
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Display passed image or placeholder
            (image ?? Image(systemName: "person.fill")) // Use provided image or default placeholder
                .resizable()
            // Use .aspectRatio for better image handling
                .aspectRatio(contentMode: .fill) // Fill the circle, might crop
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .background( // Background visible if image is transparent or not loaded
                    Circle().fill(Color.gray.opacity(0.4))
                )
                .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))
            
            // Camera Icon Overlay (remains the same)
            Image(systemName: "camera.circle.fill")
            /* ... styling ... */
                .resizable().scaledToFit().frame(width: 35, height: 35)
                .foregroundColor(accentColor)
                .background(Color(red: 34/255, green: 34/255, blue: 34/255)).clipShape(Circle())
                .overlay(Circle().stroke(Color(red: 34/255, green: 34/255, blue: 34/255), lineWidth: 3))
                .offset(x: 5, y: 5)
        }
    }
}

struct StatCardView: View {
    let item: StatItem
    let backgroundColor: Color
    var isWide: Bool = false
    
    var body: some View {
        VStack(alignment: isWide ? .leading : .center, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: item.icon)
                    .foregroundColor(.white.opacity(0.8))
                    .font(.title3) // Adjust icon size if needed
                Text(item.title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                if isWide { Spacer() } // Push content left only if wide
            }
            
            Text(item.value)
                .font(isWide ? .title : .largeTitle) // Larger font for grid items
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: isWide ? .infinity : nil, alignment: .leading) // Align left if wide
            
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: isWide ? 80 : 120, alignment: isWide ? .leading : .center) // Set min height, align center for grid
        .background(backgroundColor)
        .cornerRadius(15)
    }
}

//MARK: - Previews Block

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .preferredColorScheme(.dark)
        // Embed in TabView for context if needed
        // TabView { ProfileView().tabItem { Label("Profile", systemImage: "person.crop.circle") } }
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    var selectedImage: (UIImage?) -> Void // Callback with the selected image
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false // Set to true if you want basic editing
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        // No update needed usually
    }
    
    // Coordinator to handle delegate methods
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage(image) // Pass the selected image back
            } else {
                parent.selectedImage(nil) // Pass nil if failed
            }
            parent.presentationMode.wrappedValue.dismiss() // Dismiss picker
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.selectedImage(nil) // Indicate cancellation
            parent.presentationMode.wrappedValue.dismiss() // Dismiss picker
        }
    }
}


//MARK: - Profile Subviews & Data Structures

struct StatItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let value: String
}



