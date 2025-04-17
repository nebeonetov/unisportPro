//
//  RegisterView.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//

import SwiftUI

struct RegisterView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AuthViewModel
    
    @State private var showingStatusAlert = false
    @State private var registrationStatus: RegistrationStatus = .idle
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreedToTerms = false
    
    //MARK: - Colors
    private let backgroundColor = Color(red: 34/255, green: 34/255, blue: 34/255)
    private let accentColor = Color(red: 0.22, green: 0.85, blue: 0.32) // #38d951
    private let textFieldBackgroundColor = Color.black.opacity(0.25)
    private let secondaryTextColor = Color.gray
    
    private var isFormValid: Bool {
        return !email.isEmpty
        && email.contains("@") // Basic check
        && !fullName.isEmpty
        && !password.isEmpty
        && password.count > 5 // Example: min 6 characters
        && confirmPassword == password
        && agreedToTerms // Check terms agreement as well
    }
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    //MARK: - Header
                    HStack {
                        Image(systemName: "bolt.fill")
                            .foregroundColor(accentColor)
                            .font(.title)
                        Text("UniSport Pro")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 30) // Reduced top padding compared to login
                    
                    //MARK: - Title Text
                    VStack {
                        Text("Create Account")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Join the sport community today")
                            .font(.subheadline)
                            .foregroundColor(secondaryTextColor)
                    }
                    .padding(.bottom, 20)
                    
                    //MARK: - Full Name Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Full Name")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.footnote)
                        
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(secondaryTextColor)
                            TextField("Enter your full name", text: $fullName)
                                .foregroundColor(.white)
                                .autocapitalization(.words)
                                .disableAutocorrection(true)
                        }
                        .padding()
                        .background(textFieldBackgroundColor)
                        .cornerRadius(12)
                    }
                    
                    //MARK: - Email Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.footnote)
                        
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(secondaryTextColor)
                            TextField("Enter your email", text: $email)
                                .foregroundColor(.white)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                        .padding()
                        .background(textFieldBackgroundColor)
                        .cornerRadius(12)
                    }
                    
                    //MARK: - Password Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.footnote)
                        
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(secondaryTextColor)
                            SecureField("Create password", text: $password)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(textFieldBackgroundColor)
                        .cornerRadius(12)
                    }
                    
                    //MARK: - Confirm Password Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Confirm Password")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.footnote)
                        
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(secondaryTextColor)
                            SecureField("Confirm password", text: $confirmPassword)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(textFieldBackgroundColor)
                        .cornerRadius(12)
                    }
                    
                    //MARK: - Terms Agreement
                    HStack(alignment: .top, spacing: 10) {
                        Button {
                            agreedToTerms.toggle()
                        } label: {
                            Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                                .foregroundColor(agreedToTerms ? accentColor : secondaryTextColor)
                                .font(.title3) // Adjust size as needed
                        }
                        
                        // Use Text concatenation with foregroundColor for links
                        Button {
                            openTerms(stringURL: "https://sites.google.com/view/unisportpro/privacy-policy")
                        } label: {
                            Text("I agree to the ")
                                .foregroundColor(secondaryTextColor)
                            + Text("Terms of Service")
                                .foregroundColor(accentColor)
                            + Text(" and ")
                                .foregroundColor(secondaryTextColor)
                            + Text("Privacy Policy")
                                .foregroundColor(accentColor)
                        }
                    }
                    .font(.footnote)
                    .padding(.top, 5)
                    .frame(maxWidth: .infinity, alignment: .leading) // Align left
                    
                    //MARK: - Create Account Button
                    Button {
                        // ---> ACTION: Trigger Registration Flow <---
                        registerUser()
                    } label: {
                        Text("Create Account")
                            .font(.headline).fontWeight(.semibold)
                        // ---> Change text color based on validation state <---
                            .foregroundColor(isFormValid ? .black : .gray.opacity(0.8))
                            .frame(maxWidth: .infinity).padding()
                        // ---> Change background color based on validation state <---
                            .background(isFormValid ? accentColor : Color.gray.opacity(0.5))
                            .cornerRadius(12)
                    }
                    .padding(.top)
                    // ---> Disable button based on validation OR registration status <---
                    .disabled(!isFormValid || registrationStatus == .registering)
                    
                    Spacer() // Pushes the login button towards the bottom
                    
                    //MARK: - Login Navigation
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .foregroundColor(secondaryTextColor)
                        Button("Login") {
                            dismiss()
                        }
                        .foregroundColor(accentColor)
                        .fontWeight(.semibold)
                    }
                    .font(.footnote)
                    .padding(.bottom, 20)
                    .padding(.top, 15)
                    
                }
                .padding(.horizontal, 25)
            }
            
            if showingStatusAlert {
                             RegistrationStatusAlertView(status: $registrationStatus)
                                  // .zIndex(1) // Optional
                        }
        }
        .preferredColorScheme(.dark)
        // Add navigation title if needed, outside the ZStack
        // .navigationTitle("Create Account")
        // .navigationBarTitleDisplayMode(.inline)
    }
    
    
    private func registerUser() {
            guard isFormValid else { return } // Prevent action if form invalid

            // Dismiss keyboard
             UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

            registrationStatus = .registering
            showingStatusAlert = true

            // Simulate registration attempt using the ViewModel
            Task {
                do {
                    // ---> Call ViewModel's create user function <---
                    try await viewModel.createUser(withEmail: email, password: password, name: fullName)

                    // ---> Handle SUCCESS (Optional) <---
                    // If createUser doesn't throw, it succeeded (in a basic scenario)
                     registrationStatus = .success // You might not need this state if you navigate away
                     showingStatusAlert = false // Hide alert immediately on success
                    // Navigate away or dismiss after successful registration
                     print("Registration Successful!")
                     // dismiss() // Example: Dismiss the view

                } catch {
                    // ---> Handle FAILURE <---
                     print("Registration Failed: \(error.localizedDescription)")
                    // Set error state AFTER the simulated delay
                    // Simulate network delay even for errors for consistent UX
                     try? await Task.sleep(nanoseconds: 1_000_000_000) // Simulate 1 second delay

                     registrationStatus = .error("Incorrect data or user not found. Please try again.")
                     showingStatusAlert = true // Ensure alert is shown for error

                    // Keep error message visible for a few seconds
                     DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { // Show error for 5 seconds
                         // Only hide if it's still showing the error state
                          if case .error = registrationStatus {
                              showingStatusAlert = false
                               // Reset status after hiding
                               DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Short delay after fade out
                                   registrationStatus = .idle
                               }
                          }
                     }
                }
            }
        }
    
    func openTerms(stringURL: String) {
        if let url = URL(string: stringURL) {
            UIApplication.shared.open(url)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(viewModel: AuthViewModel())
    }
}



// Enum for registration status
enum RegistrationStatus: Equatable {
    case idle
    case registering
    case success // Optional: If you want a success state
    case error(String)
}

// Custom Alert View
struct RegistrationStatusAlertView: View {
    @Binding var status: RegistrationStatus
    
    //MARK: - Colors
    private let overlayBackground = Color.black.opacity(0.7)
    private let contentBackground = Color(red: 50/255, green: 50/255, blue: 50/255)
    private let accentColor = Color(red: 0.22, green: 0.85, blue: 0.32) // #38d951
    
    var body: some View {
        ZStack {
            overlayBackground.ignoresSafeArea()
            
            VStack(spacing: 20) {
                switch status {
                case .registering:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: accentColor))
                        .scaleEffect(1.5)
                    Text("Creating Account...")
                        .font(.headline)
                        .foregroundColor(.white)
                case .success: // Optional success state
                    Image(systemName: "checkmark.circle.fill")
                        .resizable().scaledToFit().frame(width: 50, height: 50).foregroundColor(accentColor)
                    Text("Account Created!")
                        .font(.headline).foregroundColor(.white)
                case .error(let message):
                    Image(systemName: "xmark.octagon.fill")
                        .resizable().scaledToFit().frame(width: 50, height: 50).foregroundColor(.red)
                    Text("Registration Failed")
                        .font(.headline).foregroundColor(.white)
                    Text(message)
                        .font(.caption).foregroundColor(.gray).multilineTextAlignment(.center)
                case .idle:
                    EmptyView()
                }
            }
            .padding(40)
            .background(contentBackground)
            .cornerRadius(20)
            .shadow(radius: 10)
            .transition(.scale.combined(with: .opacity))
        }
        .animation(.easeInOut, value: status)
    }
}
