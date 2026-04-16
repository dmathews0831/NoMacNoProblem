//
//  GameSelectSPView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//

import SwiftUI

struct GameSelectSPView: View {
    
    @Binding var path: [Route]
    @Binding var coins: Int
    @Binding var selectedGame: Game?
    
    var body: some View {
        VStack {
            BalanceView(coins: $coins)
            
            Spacer()
            Text("Which game would you like to play?")
                .font(.title2)
            Button("Roulette") {
                path.append(.playRoulette)
                selectedGame = .roulette
            }
            .font(.title)
            .buttonStyle(.borderedProminent)
            
            Button("Blackjack") {
                path.append(.playBlackjack)
                selectedGame = .blackjack
            }
            .font(.title)
            .buttonStyle(.borderedProminent)
            
            Spacer()
            
            Button("Back") {
                path.removeLast()
            }
            .padding()
        }
    }
}
