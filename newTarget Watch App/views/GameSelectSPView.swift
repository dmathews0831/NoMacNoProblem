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
            
            Button("Roulette") {
                path.append(.playRoulette)
                selectedGame = .roulette
            }
            .font(.title)
            .buttonStyle(.borderedProminent)
            .tint(.red)
            
            Button("Blackjack") {
                path.append(.playBlackjack)
                selectedGame = .blackjack
            }
            .font(.title)
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            
            Spacer()
            
            Button("Back") {
                path.removeLast()
            }
            .padding()
        }
    }
}
