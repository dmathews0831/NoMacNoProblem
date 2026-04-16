//
//  CPUSelectView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//

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
            
            Button("Back") {
                path.removeLast()
                selectedGame = nil
                selectedCPUCount = nil
            }
            .padding()
        }
    }
}
