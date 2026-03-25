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
    @Binding var availableCPUOptions: [Int]
    
    var body: some View {
        
        // Compute the players winnings/losses
        var netWinnings: Int = coins - startingCoins
        
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
        }
    }
}
