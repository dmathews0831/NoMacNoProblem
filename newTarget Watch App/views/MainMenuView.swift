//
//  MainMenuView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/22/26.
//
// Task 1 & 2: Claim Daily Bonus and View Balance
// Custom Views - Reusable component with navigation logic
// Data Binding - Uses @Binding for reactive coin and path updates
// Visually Interesting UI - Clean layout with large PLAY button and system icons
// Responsiveness - Adapted for watch screen with smaller fonts (title2, title3)

import SwiftUI

struct MainMenuView: View {
    
    @Binding var path: [Route]
    @Binding var coins: Int
    
    // Task 1: Claim Daily Bonus
    // Procedural Programming - Closure adds 1000 coins to balance
    var claimBonusView: some View {
        Button("CLAIM DAILY BONUS") {
            coins += 1000
        }
        .buttonStyle(.borderedProminent)
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Mobile Casino")
                .font(.title2)
            
            Spacer()
            // Task 2: View Balance - BalanceView custom component displays current coins
            BalanceView(coins: $coins)  // Data Binding - Passes binding to child view
            claimBonusView
            
            Spacer()
            
            // Navigation Stacks - Button navigates to gameSelectSP route
            Button("PLAY") {
                path.append(.gameSelectSP)  // Functional - Closure for navigation
            }
            .font(.title)
            .tint(.green)
            
            Spacer()
            
            HStack {
                // Task 4: Settings - Navigate to settings view
                Button {
                    path.append(.settings)
                } label: {
                    Image(systemName: "gearshape.fill")  // Visually Interesting UI - System icon
                        .font(.title3)
                }
                
                Spacer()
                
                // Task 5: User Profile - Navigate to profile view
                Button {
                    path.append(.profile)  // Navigation Stacks - Profile route
                } label: {
                    Image(systemName: "person.circle.fill")  // Visually Interesting UI - System icon
                        .font(.title3)
                }
            }
            .padding()
        }
    }
}
