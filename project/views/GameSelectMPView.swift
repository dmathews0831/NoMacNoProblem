//
//  GameSelectMPView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//
// Description: This file contains the multiplayer game select view which allows the host to select the game to play and the player settings.

import SwiftUI

struct GameSelectMPView: View {
    
    @Binding var path: [Route]
    @Binding var coins: Int
    @Binding var selectedGame: Game?
    @Binding var selectedPlayerCount: Int?
    @Binding var selectedCPUCount: Int?
    //@Binding var availableCPUOptions: [Int]
    
    // List of available CPUs based on the selected number of players during multiplayer select (host)
    var availableCPUOptions: [Int] {
        guard let humans = selectedPlayerCount else { return [] }
        return Array(0...(maxPlayers - humans))
    }
    
    var body: some View {
        VStack {
            BalanceView(coins: $coins)
            
            Spacer()
            
            // Roulette button
            Text("Select game to host")
                .font(.title2)
                .foregroundStyle(.white)
            Button("Roulette") {
                selectedGame = .roulette
            }
            .font(.title)
            .frame(width: 150, height: 50)
            .background(selectedGame == .roulette ? SwiftUI.Color(.blue) : SwiftUI.Color(.gray).opacity(0.3))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            
            // Blackjack button
            Button("Blackjack") {
                selectedGame = .blackjack
            }
            .font(.title)
            .frame(width: 150, height: 50)
            .background(selectedGame == .blackjack ? SwiftUI.Color(.blue) : SwiftUI.Color(.gray).opacity(0.3))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            
            Spacer()
            
            VStack(spacing: 20) {
                
                // Human Players Picker
                VStack {
                    Text("Number of Human Players")
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Picker("Humans", selection: $selectedPlayerCount) {
                        Text("Select").tag(Int?.none)
                        ForEach(1...maxHumans, id: \.self) { num in
                            Text("\(num)").tag(Optional(num))
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                // CPU Players Picker
                VStack {
                    Text("Number of CPUs")
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Picker("CPUs", selection: $selectedCPUCount) {
                        Text("Select").tag(Int?.none)
                        ForEach(availableCPUOptions, id: \.self) { num in
                            Text("\(num)").tag(Optional(num))
                        }
                    }
                    .pickerStyle(.menu)
                    .disabled(selectedPlayerCount == nil)
                }
            }
            .padding()
            
            Spacer()
            
            // Button to start the game
            // Only clickable when all settings have been selected
            Button("Launch Game") {
                if (selectedGame != nil &&
                    selectedPlayerCount != nil &&
                    selectedCPUCount != nil) {
                    path.append(.waitingRoom)
                }
            }
            .font(.title)
            .frame(width: 200, height: 100)
            .background((selectedGame != nil &&
                         selectedPlayerCount != nil &&
                         selectedCPUCount != nil)
                        ? SwiftUI.Color(.red) : SwiftUI.Color(.gray).opacity(0.3))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            
            Spacer()
            
            // Back button
            Button("Back") {
                path.removeLast()
                selectedGame = nil
                selectedPlayerCount = nil
                selectedCPUCount = nil
            }
            .padding()
            .foregroundStyle(.white)
        }
    }
}
