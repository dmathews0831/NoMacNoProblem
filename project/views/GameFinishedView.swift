//
//  GameFinishedView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//
//  Description: This file contains the game finished view which displays the player's winnings/losses after a game is finished.

import SwiftUI

struct GameFinishedView: View {
    
    @Binding var path: [Route]
    @Binding var coins: Int
    @Binding var startingCoins: Int
    @Binding var selectedGame: Game?
    @Binding var selectedPlayerCount: Int?
    @Binding var selectedCPUCount: Int?
    
    var body: some View {
        
        // Compute the players winnings/losses
        let netWinnings: Int = coins - startingCoins
        
        VStack {
            BalanceView(coins: $coins)
            Spacer()
            
            // Display the player winnings/losses
            if netWinnings > 0 {
                Text("You won: +\(netWinnings)")
                    .font(.title)
                    .foregroundColor(.green)
            }
            else if netWinnings < 0 {
                Text("You lost: \(netWinnings)")
                    .font(.title)
                    .foregroundColor(.red)
            }
            else {
                Text("No change in your balance")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            Button("Leave") {
                path.append(.mainMenu)
                selectedGame = nil
                selectedPlayerCount = nil
                selectedCPUCount = nil
            }
            .foregroundStyle(.white)
        }
    }
}
