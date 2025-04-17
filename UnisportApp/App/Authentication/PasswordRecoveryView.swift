//
//  PasswordRecoveryView.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//
//MARK: - Password Recovery View Block (With Custom Alert)

import SwiftUI

struct PasswordRecoveryView: View {

    @State private var email = ""
    @Environment(\.presentationMode) var presentationMode

    // ---> NEW State Variables for Alert <---
    @State private var showingStatusAlert = false
    @State private var recoveryStatus: RecoveryStatus = .idle

    //MARK: - Colors
    private let backgroundColor = Color(red: 34/255, green: 34/255, blue: 34/255)
    private let accentColor = Color(red: 0.22, green: 0.85, blue: 0.32) // #38d951
    private let textFieldBackgroundColor = Color.black.opacity(0.25)
    private let secondaryTextColor = Color.gray
    private let iconBackgroundColor = Color.black.opacity(0.4)

    var body: some View {
        NavigationView {
            // ---> Use ZStack for Overlay <---
            ZStack {
                backgroundColor.ignoresSafeArea()

                //MARK: - Main Content VStack
                VStack(spacing: 25) {
                    // Lock Icon ...
                     Image(systemName: "lock.fill").font(.title).foregroundColor(accentColor)
                         .padding(20).background(iconBackgroundColor).clipShape(Circle()).padding(.top, 40)

                    // Title & Subtitle ...
                     VStack(spacing: 10) {
                         Text("Password Recovery").font(.title2).fontWeight(.bold).foregroundColor(.white)
                         Text("Enter your email address and we'll send you instructions to reset your password")
                              .font(.subheadline).foregroundColor(secondaryTextColor).multilineTextAlignment(.center).padding(.horizontal)
                     }.padding(.bottom, 20)

                    // Email Field ...
                     VStack(alignment: .leading, spacing: 8) {
                          Text("Email Address").foregroundColor(.white.opacity(0.8)).font(.footnote)
                          HStack {
                               Image(systemName: "envelope").foregroundColor(secondaryTextColor)
                               TextField("Enter your email", text: $email)
                                    .foregroundColor(.white).keyboardType(.emailAddress).autocapitalization(.none).disableAutocorrection(true)
                          }.padding().background(textFieldBackgroundColor).cornerRadius(12)
                     }

                    // Send Instructions Button ...
                    Button {
                         // ---> ACTION: Trigger Alert Flow <---
                         sendRecoveryInstructions()
                    } label: {
                        Text("Send Instructions")
                            .font(.headline).fontWeight(.semibold).foregroundColor(.black)
                            .frame(maxWidth: .infinity).padding().background(accentColor).cornerRadius(12)
                    }
                    .padding(.top)
                    // ---> Disable button if email is empty or sending <---
                     .disabled(email.isEmpty || recoveryStatus == .sending)
                     .opacity((email.isEmpty || recoveryStatus == .sending) ? 0.6 : 1.0) // Visual feedback


                    Spacer()
                }
                .padding(.horizontal, 25)
                 // Disable interaction with background elements when alert is shown
                 .disabled(showingStatusAlert)

                //MARK: - Alert Overlay
                 if showingStatusAlert {
                      RecoveryStatusAlertView(status: $recoveryStatus)
                         .onDisappear {
                             
                         }
                           // Add zIndex if needed, but should be on top if placed last in ZStack
                           // .zIndex(1)
                 }

            } // End ZStack
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Password Recovery")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss() // Action for back button
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white) // Style the back button
                    }
                }
            }
             // Animate the appearance/disappearance of the alert overlay
             .animation(.easeInOut, value: showingStatusAlert)
        }
        .navigationViewStyle(.stack)
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.dark)
    }

    //MARK: - Action Function
    private func sendRecoveryInstructions() {
         // Dismiss keyboard
         UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

         guard !email.isEmpty else { return } // Double check

         recoveryStatus = .sending
         showingStatusAlert = true

         // Simulate network delay
         DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
              // Assume success for now
              recoveryStatus = .sent

              // Keep success message visible for a bit
              DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                   showingStatusAlert = false
                   // Optionally dismiss the view after success
                   presentationMode.wrappedValue.dismiss()
                   // Reset status for next time (optional, depends on flow)
                   // recoveryStatus = .idle
              }
         }
    }
}

struct PasswordRecoveryView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordRecoveryView()
    }
}



//MARK: - Recovery Status Alert Block
// RecoveryStatusAlert.swift (New File or add to existing utilities)

import SwiftUI

// Enum for recovery status
enum RecoveryStatus: Equatable {
    case idle
    case sending
    case sent
    case error(String) // Optional error state
}

// Custom Alert View
struct RecoveryStatusAlertView: View {
    @Binding var status: RecoveryStatus // Use Binding to react to changes

    //MARK: - Colors
    private let overlayBackground = Color.black.opacity(0.7)
    private let contentBackground = Color(red: 50/255, green: 50/255, blue: 50/255)
    private let accentColor = Color(red: 0.22, green: 0.85, blue: 0.32) // #38d951

    var body: some View {
        ZStack {
            // Dimmed background
            overlayBackground.ignoresSafeArea()

            // Content Box
            VStack(spacing: 20) {
                switch status {
                case .sending:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: accentColor))
                        .scaleEffect(1.5)
                    Text("Sending Instructions...")
                        .font(.headline)
                        .foregroundColor(.white)
                case .sent:
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(accentColor)
                    Text("Instructions Sent!")
                        .font(.headline)
                        .foregroundColor(.white)
                case .error(let message):
                     Image(systemName: "xmark.octagon.fill")
                         .resizable().scaledToFit().frame(width: 50, height: 50).foregroundColor(.red)
                     Text("Error").font(.headline).foregroundColor(.white)
                     Text(message).font(.caption).foregroundColor(.gray).multilineTextAlignment(.center)
                case .idle:
                    EmptyView() // Should not be visible when overlay is active
                }
            }
            .padding(40)
            .background(contentBackground)
            .cornerRadius(20)
            .shadow(radius: 10)
            .transition(.scale.combined(with: .opacity)) // Animate appearance
        }
         // Animate based on the status change itself if needed, but transition handles appearance
         .animation(.easeInOut, value: status)
    }
}
