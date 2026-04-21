//
//  ProfileView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//
//  Description: This file contains the user profile sign-in which allows the user to login with their Apple Account.

import SwiftUI
import AuthenticationServices

struct ProfileView: View {
    
    @Binding var path: [Route]
    
    // Authentication view model
    @StateObject private var authVM = AuthViewModel()
        
    var body: some View {
        VStack(spacing: 20) {
            Text("Profile")
                .font(.title)
                .foregroundStyle(.white)
                .padding()
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
            // Otherwise, display sign-in with Apple Account button
            else {
                SignInWithAppleButton(
                    .signIn,
                    onRequest: authVM.handleSignInWithAppleRequest,
                    onCompletion: authVM.handleSignInWithAppleCompletion
                )
                .signInWithAppleButtonStyle(.black)
                .frame(height: 50)
                .padding()
            }
            Spacer()
            // Back button
            Button("Back") {
                path.removeLast()
            }
            .foregroundStyle(.white)
        }
    }
}
