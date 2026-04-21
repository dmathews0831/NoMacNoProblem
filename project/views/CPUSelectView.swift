//
//  CPUSelectView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//
//  Description: This file contains the CPU select view where the player can select how many CPUs they want to play against. Currently just for demonstration.

import SwiftUI

struct CPUSelectView: View {
    
    @Binding var path: [Route]
    @Binding var coins: Int
    @Binding var selectedGame: Game?
    @Binding var selectedPlayerCount: Int?
    @Binding var selectedCPUCount: Int?
    //@Binding var availableCPUOptions: [Int]
    @Binding var startingCoins: Int
    
    // List of available CPUs based on the selected number of players during multiplayer select (host)
    var availableCPUOptions: [Int] {
        guard let humans = selectedPlayerCount else { return [] }
        return Array(0...(maxPlayers - humans))
    }
    
    var body: some View {
        VStack {
            BalanceView(coins: $coins)
            
            Spacer()
            
            Text("Select Number of CPUs")
                .font(.title2)
                .foregroundStyle(.white)
            // Display the options for number of CPUs
            HStack {
                ForEach(1...maxPlayers, id: \.self) { num in
                    Button("\(num)") {
                        selectedCPUCount = num
                    }
                    .frame(width: 60, height: 60)
                    .background(selectedCPUCount == num ? SwiftUI.Color.blue : SwiftUI.Color.gray.opacity(0.3))
                    .foregroundColor(.white)
                    .clipShape(Circle())
                }
            }
            .padding()
            
            Spacer()
            
            // Play button to take the player to the selected game
            Button("PLAY") {
                if (selectedGame == .roulette) {
                    path.append(.playRoulette)
                    startingCoins = coins
                }
                else if (selectedGame == .blackjack) {
                    path.append(.playBlackjack)
                }
            }
            .font(.title)
            .buttonStyle(.borderedProminent)
            .disabled(selectedCPUCount == nil)
            
            Spacer()
            
            // Back button
            Button("Back") {
                path.removeLast()
                selectedGame = nil
                selectedCPUCount = nil
            }
            .padding()
            .foregroundStyle(.white)
        }
    }
}
