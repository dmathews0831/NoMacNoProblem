//
//  WaitingRoomView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//
//  Description: This file contains the waiting room view for players waiting to join a multiplayer game. Currently just for demonstration.

import SwiftUI

struct WaitingRoomView: View {
    
    @Binding var path: [Route]
    @Binding var coins: Int
    @Binding var selectedGame: Game?
    @Binding var selectedPlayerCount: Int?
    @Binding var selectedCPUCount: Int?
    @Binding var startingCoins: Int
    
    var body: some View {
        VStack {
            BalanceView(coins: $coins)
            
            Spacer()
            
            Text("Waiting Room")
                .foregroundStyle(.white)
            
            // Button for the host to start the game
            Button("Start Game") {
                if (selectedGame == .roulette) {
                    path.append(.playRoulette)
                    startingCoins = coins
                }
                else if (selectedGame == .blackjack) {
                    path.append(.playRoulette)
                    startingCoins = coins
                }
            }
            .font(.title)
            .frame(width: 150, height: 100)
            .background((selectedGame != nil &&
                         selectedPlayerCount != nil &&
                         selectedCPUCount != nil)
                        ? SwiftUI.Color(.blue) : SwiftUI.Color(.gray).opacity(0.3))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            
            Spacer()
            
            // Button to leave the room
            Button("Leave Room") {
                path.append(.mainMenu)
                selectedGame = nil
                selectedPlayerCount = nil
                selectedCPUCount = nil
            }
            .padding()
            .foregroundStyle(.white)
        }
    }
}
