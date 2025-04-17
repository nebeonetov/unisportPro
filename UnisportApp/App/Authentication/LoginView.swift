//
//  LoginView.swift
//  UnisportApp
//
//  Created by D K on 14.04.2025.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var viewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    
    @State private var recoveryShown = false
    @State private var showingStatusAlert = false
    @State private var loginStatus: LoginStatus = .idle
    
    @State private var isWelcomeShown = true
    
    //MARK: - Colors
    private let backgroundColor = Color(red: 34/255, green: 34/255, blue: 34/255)
    private let accentColor = Color(red: 0.22, green: 0.85, blue: 0.32) // #38d951
    private let textFieldBackgroundColor = Color.black.opacity(0.25)
    private let secondaryTextColor = Color.gray
    
    private var isFormValid: Bool {
        !email.isEmpty && email.contains("@") && !password.isEmpty
    }
    
    var body: some View {
        NavigationStack {
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
                        .padding(.top, 50)
                        
                        //MARK: - Welcome Text
                        VStack {
                            Text("Welcome Back!")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("Login to continue your sport journey")
                                .font(.subheadline)
                                .foregroundColor(secondaryTextColor)
                        }
                        .padding(.bottom, 20)
                        
                        
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
                                SecureField("Enter your password", text: $password)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(textFieldBackgroundColor)
                            .cornerRadius(12)
                            
                            HStack {
                                Spacer()
                                Button("Forgot Password?") {
                                    recoveryShown.toggle()
                                }
                                .font(.footnote)
                                .foregroundColor(accentColor)
                            }
                        }
                        
                        //MARK: - Login Button
                        Button {
                            // ---> ACTION: Trigger Login Flow <---
                            loginUser()
                        } label: {
                            Text("Login")
                                .font(.headline).fontWeight(.semibold)
                            // ---> Change text color based on validation <---
                                .foregroundColor(isFormValid ? .white : .gray.opacity(0.8))
                                .frame(maxWidth: .infinity).padding()
                            // ---> Change background based on validation <---
                                .background(isFormValid ? accentColor : Color.gray.opacity(0.5))
                                .cornerRadius(12)
                        }
                        .padding(.top)
                        // ---> Disable button based on validation OR login status <---
                        .disabled(!isFormValid || loginStatus == .loggingIn)
                        
                        
                        //MARK: - Divider
                        HStack {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(secondaryTextColor.opacity(0.5))
                            Text("Or continue with")
                                .font(.caption)
                                .foregroundColor(secondaryTextColor)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 5)
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(secondaryTextColor.opacity(0.5))
                        }
                        
                        
                        //MARK: - Alternative Logins
                        HStack(spacing: 15) {
                            Button {
                                anonymousLogin()
                            } label: {
                                Label("Anonymous", systemImage: "person.fill.questionmark")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(textFieldBackgroundColor)
                                    .cornerRadius(12)
                            }
                            
                        }
                        
                        Spacer() // Pushes the register button towards the bottom if content is short
                        
                        //MARK: - Register Navigation
                        HStack(spacing: 4) {
                            Text("Don't have an account?")
                                .foregroundColor(secondaryTextColor)
                            
                            NavigationLink {
                                RegisterView(viewModel: viewModel)
                                    .navigationBarBackButtonHidden()
                            } label: {
                                Text("Register")
                                    .foregroundColor(accentColor)
                                    .fontWeight(.semibold)
                            }
                            
                            
                        }
                        .font(.footnote)
                        .padding(.bottom, 20) // Ensure some padding from bottom edge
                        .padding(.top, 10)
                        
                        
                    }
                    .padding(.horizontal, 25)
                }
                
                if showingStatusAlert {
                    LoginStatusAlertView(status: $loginStatus)
                    // .zIndex(1) // Optional
                }
            }
        }
        .fullScreenCover(isPresented: $recoveryShown) {
            PasswordRecoveryView()
        }
        .fullScreenCover(isPresented: $isWelcomeShown) {
            OnboardingContainerView()
        }
        .preferredColorScheme(.dark) // Ensure system elements like keyboard are dark
    }
    
    func anonymousLogin() {
        loginStatus = .loggingIn
        showingStatusAlert = true
        
        Task {
            await viewModel.signInAnonymously()
            
            try? await Task.sleep(nanoseconds: 1_000_000_000) // Simulate 1 second delay
            
            loginStatus = .error("Error occurred. Please try again.") // Use specific error message from 'error' if possible
            showingStatusAlert = true // Ensure alert stays visible for error
            
            // Keep error message visible for 5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                if case .error = loginStatus { // Hide only if still showing error
                    showingStatusAlert = false
                    // Reset status after hiding
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        loginStatus = .idle
                    }
                }
            }
        }
    }
    
    private func loginUser() {
        guard isFormValid else { return }
        
        // Dismiss keyboard
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        loginStatus = .loggingIn
        showingStatusAlert = true
        
        Task {
            do {
                // ---> Call ViewModel's sign in function <---
                try await viewModel.signIn(email: email, password: password)
                
                try? await Task.sleep(nanoseconds: 1_000_000_000) // Simulate 1 second delay
                
                loginStatus = .error("Incorrect data or user not found. Please try again.") // Use specific error message from 'error' if possible
                showingStatusAlert = true // Ensure alert stays visible for error
                
                // Keep error message visible for 5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    if case .error = loginStatus { // Hide only if still showing error
                        showingStatusAlert = false
                        // Reset status after hiding
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            loginStatus = .idle
                        }
                    }
                }
                
            } catch {
                // ---> Handle FAILURE <---
                print("Login Failed: \(error.localizedDescription)")
                // Simulate network delay for consistent UX
                try? await Task.sleep(nanoseconds: 1_000_000_000) // Simulate 1 second delay
                
                loginStatus = .error("Incorrect data or user not found. Please try again.") // Use specific error message from 'error' if possible
                showingStatusAlert = true // Ensure alert stays visible for error
                
                // Keep error message visible for 5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    if case .error = loginStatus { // Hide only if still showing error
                        showingStatusAlert = false
                        // Reset status after hiding
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            loginStatus = .idle
                        }
                    }
                }
            }
        }
    }
    
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: AuthViewModel())
    }
}

// Enum for login status
enum LoginStatus: Equatable {
    case idle
    case loggingIn
    case success // Optional: Usually navigate away on success
    case error(String)
}

// Custom Alert View
struct LoginStatusAlertView: View {
    @Binding var status: LoginStatus
    
    //MARK: - Colors
    private let overlayBackground = Color.black.opacity(0.7)
    private let contentBackground = Color(red: 50/255, green: 50/255, blue: 50/255)
    private let accentColor = Color(red: 0.22, green: 0.85, blue: 0.32) // #38d951
    
    var body: some View {
        ZStack {
            overlayBackground.ignoresSafeArea()
            
            VStack(spacing: 20) {
                switch status {
                case .loggingIn:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: accentColor))
                        .scaleEffect(1.5)
                    Text("Logging In...")
                        .font(.headline)
                        .foregroundColor(.white)
                case .success: // Optional success state if needed before navigation
                    Image(systemName: "checkmark.circle.fill")
                        .resizable().scaledToFit().frame(width: 50, height: 50).foregroundColor(accentColor)
                    Text("Login Successful!")
                        .font(.headline).foregroundColor(.white)
                case .error(let message):
                    Image(systemName: "xmark.octagon.fill")
                        .resizable().scaledToFit().frame(width: 50, height: 50).foregroundColor(.red)
                    Text("Login Failed")
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
        .animation(.easeInOut, value: status) // Animate status changes
    }
}
