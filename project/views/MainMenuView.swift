//
//  MainMenuView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/22/26.
//
// Task 1 & 2: Claim Daily Bonus and View Balance
// Custom Views - Reusable component with navigation logic
// Data Binding - Uses @Binding for reactive coin and path updates
// Visually Interesting UI - Clean layout with large blue PLAY button and system icons
// Images & Resources - Uses CasinoBackground image via parent view

import SwiftUI

struct MainMenuView: View {
    
    @Binding var path: [Route]
    @Binding var coins: Int
    
    // Task 1: Claim Daily Bonus
    // Procedural Programming - Closure adds 1000 coins to balance
    // FUNCTIONAL REQUIREMENT: The player should be able to collect their daily coin bonus
    var claimBonusView: some View {
        Button("CLAIM DAILY BONUS") {
            coins += 1000
        }
        .buttonStyle(.borderedProminent)
        .tint(.yellow)
    }
    
    var body: some View {
        VStack {
            // Task 2: View Balance - BalanceView custom component displays current coins
            BalanceView(coins: $coins)  // Data Binding - Passes binding to child view
            claimBonusView
            
            Spacer()
            
            ZStack {
                PokerChipView(color: .red, size: 260)
                Text("Mobile Casino")
                    .padding(5)
                    .font(Font.largeTitle.bold())
                    .foregroundStyle(.black)
                    .background(.white)
                    .opacity(0.9)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
            }
            
            Spacer()
            
            // Navigation Stacks - Button navigates to playSelect route
            Button("PLAY") {
                path.append(.playSelect)  // Functional - Closure for navigation
            }
            .font(.largeTitle)
            .frame(width: 200, height: 100)
            .background(.yellow)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            
            Spacer()
            
            HStack {
                // Task 4: Settings - Navigate to settings view
                Button {
                    path.append(.settings)
                } label: {
                    Image(systemName: "gearshape.fill")  // Visually Interesting UI - System icon
                        .font(.title)
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                // Task 5: User Profile - Navigate to profile view
                Button {
                    path.append(.profile)  // Navigation Stacks - Profile route
                } label: {
                    Image(systemName: "person.circle.fill")  // Visually Interesting UI - System icon
                        .font(.title)
                        .foregroundStyle(.white)
                }
            }
            .padding()
        }
    }
}
