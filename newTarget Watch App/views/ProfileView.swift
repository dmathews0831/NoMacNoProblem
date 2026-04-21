//
//  ProfileView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//
// TASK 5: User Profile Management - Apple Sign-In
// Custom Views - ProfileView component with authentication UI
// Data Binding - @StateObject for AuthViewModel observable object
// Responsiveness - Simplified for watch display

import SwiftUI
import AuthenticationServices

struct ProfileView: View {
    
    @Binding var path: [Route]
    
    // Data Binding - @StateObject manages AuthViewModel (Combine observable object)
    @StateObject private var authVM = AuthViewModel()
        
    var body: some View {
        VStack(spacing: 20) {
            Text("Profile")
                .font(.caption)
            Spacer()
            // Check if the user is logged in
            // If so, display log out button
            if authVM.isLoggedIn {
                Text("Logged in!")
                Button("Log Out") {
                    authVM.isLoggedIn = false
                    UserDefaults.standard.removeObject(forKey: "userID")
                }
            }
            // Otherwise, display sign-in with Apple ID button
            else {
                SignInWithAppleButton(
                    .signIn,
                    onRequest: authVM.handleSignInWithAppleRequest,
                    onCompletion: authVM.handleSignInWithAppleCompletion
                )
                .signInWithAppleButtonStyle(.black)
                .frame(height: 50)
            }
            Spacer()
            // Back button
            Button("Back") {
                path.removeLast()
            }
        }
    }
}
