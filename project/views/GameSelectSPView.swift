//
//  GameSelectSPView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//
//  Description: This file contains the single player game select view which allows the player to select which game they want to play

import SwiftUI

struct GameSelectSPView: View {
    
    @Binding var path: [Route]
    @Binding var coins: Int
    @Binding var selectedGame: Game?
    
    var body: some View {
        VStack {
            BalanceView(coins: $coins)
            
            Spacer()
            
            // Roulette button
            Text("Which game would you like to play?")
                .font(.title2)
                .foregroundStyle(.white)
            Button("Roulette") {
                path.append(.CPUSelect)
                selectedGame = .roulette
            }
            .font(.title)
            .buttonStyle(.borderedProminent)
            .tint(.red)
            
            // Blackjack button
            Button("Blackjack") {
                path.append(.CPUSelect)
                selectedGame = .blackjack
            }
            .font(.title)
            .buttonStyle(.borderedProminent)
            
            Spacer()
            
            // Back button
            Button("Back") {
                path.removeLast()
            }
            .padding()
            .foregroundStyle(.white)
        }
    }
}
