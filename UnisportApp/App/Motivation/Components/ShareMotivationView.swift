//
//  ShareMotivationView.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//


import SwiftUI

struct ShareMotivationView: View {
    @Binding var isPresented: Bool // To dismiss the sheet
    @State private var message: String = ""
    @State private var showingSubmissionStatus = false
    @State private var submissionState: SubmissionState = .idle

    //MARK: - Colors
    private let backgroundColor = Color(red: 34/255, green: 34/255, blue: 34/255)
    private let cardBackgroundColor = Color.black.opacity(0.25)
    private let accentColor = Color(red: 0.22, green: 0.85, blue: 0.32) // #38d951
    private let secondaryTextColor = Color.gray
    private let placeholderTextColor = Color.gray

    private let characterLimit = 300

    var body: some View {
        NavigationView {
            ZStack { // Use ZStack for overlay
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {

                        //MARK: - User Info Header
                        HStack {
                            Image(systemName: "person.crop.circle.fill") // Placeholder Avatar
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white.opacity(0.8))
                                .background(Color.gray.opacity(0.5))
                                .clipShape(Circle())

                            VStack(alignment: .leading) {
                                Text("Posting as")
                                    .font(.caption)
                                    .foregroundColor(secondaryTextColor)
                                Text("Anonymous Athlete")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)

                        //MARK: - Message Input
                        VStack(alignment: .leading, spacing: 8) {
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $message)
                                    .scrollContentBackground(.hidden)
                                    .foregroundColor(.white)
                                    .frame(height: 150) // Fixed height for text editor
                                    .padding(12)
                                    .background(cardBackgroundColor)
                                    .cornerRadius(10)
                                    .tint(accentColor)
                                    .onChange(of: message) { newValue in
                                        // Enforce character limit
                                        if newValue.count > characterLimit {
                                            message = String(newValue.prefix(characterLimit))
                                        }
                                    }


                                if message.isEmpty {
                                    Text("Write your motivational message here...")
                                        .foregroundColor(placeholderTextColor)
                                        .padding(.horizontal, 17) // Adjust padding to match TextEditor
                                        .padding(.vertical, 20)
                                        .allowsHitTesting(false)
                                }
                            }

                            // Character Count
                            Text("\(message.count)/\(characterLimit)")
                                .font(.caption)
                                .foregroundColor(secondaryTextColor)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.horizontal)

                        //MARK: - Community Guidelines
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "list.bullet.clipboard.fill")
                                    .foregroundColor(accentColor)
                                Text("Community Guidelines")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }

                            GuidelineRow(text: "Keep your message positive and supportive")
                            GuidelineRow(text: "Avoid offensive language and personal attacks")
                            GuidelineRow(text: "Share genuine experiences and encouragement")
                        }
                        .padding()
                        .background(cardBackgroundColor)
                        .cornerRadius(15)
                        .padding(.horizontal)


                        Spacer() // Push button down

                    }
                    .padding(.top) // Add padding at the top of scroll content

                } // End ScrollView
                 .background(backgroundColor.ignoresSafeArea())


                //MARK: - Submission Status Overlay
                 if showingSubmissionStatus {
                     SubmissionStatusOverlayView(submissionState: $submissionState)
                 }

            } // End ZStack
            .navigationTitle("Share your motivation")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button { isPresented = false } label: {
                 Image(systemName: "arrow.left")
                     .foregroundColor(.white)
            })
            .safeAreaInset(edge: .bottom) { // Place button at bottom safely
                 Button {
                      submitMotivation()
                 } label: {
                      Label("Submit for moderation", systemImage: "paperplane.fill")
                          .font(.headline)
                          .fontWeight(.semibold)
                          .foregroundColor(.black)
                          .frame(maxWidth: .infinity)
                          .padding()
                          .background(message.isEmpty ? Color.gray : accentColor) // Disable visually if empty
                          .cornerRadius(12)
                 }
                 .disabled(message.isEmpty)
                 .padding()
                 .background(backgroundColor) // Ensure button background matches view
            }
            .preferredColorScheme(.dark)
        }
         .navigationViewStyle(.stack) // Important for sheets containing NavigationViews
    }

    private func submitMotivation() {
        guard !message.isEmpty else { return }

        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) // Dismiss keyboard

        submissionState = .submitting
        showingSubmissionStatus = true

        // Simulate network request / moderation check
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            submissionState = .success
            // Keep showing success for a bit longer
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                 showingSubmissionStatus = false
                 isPresented = false // Dismiss the share sheet after success
            }
        }
    }
}

//MARK: - Guideline Row Helper
struct GuidelineRow: View {
    let text: String
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
    }
}
