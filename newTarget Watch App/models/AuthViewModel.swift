//
//  AuthViewModel.swift
//  project
//
//  Created by Alexander Joseph Toskey on 4/19/26.
//
//  Description: This file contains the authentication model for the user sign-in.

import SwiftUI
import AuthenticationServices
import Combine

class AuthViewModel: NSObject, ObservableObject {
    
    // Boolean which says if the user has logged in
    @Published var isLoggedIn: Bool = false
    
    // User ID string
    @Published var userID: String? = nil
    
    // Handle the sign-in request
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    // Handle the end status of the sign-in, display success or failure message
    // NON-FUNCTIONAL REQUIREMENT: The user login feature should be conducted securely, preferably using Apple Sign-in
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
                
                let userID = appleIDCredential.user
                self.userID = userID
                self.isLoggedIn = true
                
                // Save to persistent storage
                UserDefaults.standard.set(userID, forKey: "userID")
                
                print("User logged in with Apple. ID: \(userID)")
            }
        // Display an error message if the sign-in failed
        // NON-FUNCTIONAL REQUIREMENT: App should default to using AppStorage if Apple Sign-in fails
        case .failure(let error):
            print("Authorization failed: \(error.localizedDescription)")
        }
    }
}
