//
//  GameFinishedView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//

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
                    .font(.caption)
                    .foregroundColor(.green)
            }
            else if netWinnings < 0 {
                Text("You lost: \(netWinnings)")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            else {
                Text("No change in your balance")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            Button("Leave") {
                path.append(.mainMenu)
                selectedGame = nil
                selectedPlayerCount = nil
                selectedCPUCount = nil
            }
        }
    }
}
