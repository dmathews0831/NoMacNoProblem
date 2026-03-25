//
//  GameSelectMPView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//

import SwiftUI

struct GameSelectMPView: View {
    
    @Binding var path: [Route]
    @Binding var coins: Int
    @Binding var selectedGame: Game?
    @Binding var selectedPlayerCount: Int?
    @Binding var selectedCPUCount: Int?
    @Binding var availableCPUOptions: [Int]
    
    var body: some View {
        VStack {
            BalanceView(coins: $coins)
            
            Spacer()
            
            Text("Select game to host")
                .font(.title2)
            Button("Roulette") {
                selectedGame = .roulette
            }
            .font(.title)
            .frame(width: 150, height: 50)
            .background(selectedGame == .roulette ? SwiftUI.Color(.blue) : SwiftUI.Color(.gray).opacity(0.3))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            
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
            
            Button("Back") {
                path.append(.joinHost)
                selectedGame = nil
                selectedPlayerCount = nil
                selectedCPUCount = nil
            }
        }
    }
}
