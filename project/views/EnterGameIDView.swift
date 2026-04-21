//
//  EnterGameIDView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//
//  Description: This file contains the game ID entering view where the player can enter a game ID to play in multiplayer. Currently just for demonstration.

import SwiftUI

struct EnterGameIDView: View {
    
    @Binding var path: [Route]
    @Binding var coins: Int
    @Binding var selectedGame: Game?
    @Binding var gameID: String
    //@Binding var isValidGameID: Bool
    
    // Boolean which determines if the user enters a valid game ID
    var isValidGameID: Bool {
        gameID.count == 3 && gameID.allSatisfy { $0.isNumber }
    }
    
    var body: some View {
        VStack {
            BalanceView(coins: $coins)
            
            Spacer()
            
            Text("Enter Game ID")
                .font(.title2)
                .foregroundStyle(.white)
            
            // Field to enter the game ID
            // Only allow the player to enter 3 numeric characters
            TextField("3-digit ID", text: $gameID)
                //.keyboardType(.numberPad)
                //.textFieldStyle(.roundedBorder)
                .frame(width: 150)
                //.multilineTextAlignment(.center)
                .onChange(of: gameID) {
                    // Restrict to digits and max length of 3
                    gameID = String(gameID.filter { $0.isNumber }.prefix(3))
                }
                .foregroundStyle(.white)
            
            Spacer()
            
            // Join button to take the player to the waiting room
            Button("JOIN") {
                if isValidGameID {
                    path.append(.waitingRoom)
                }
            }
            .font(.title)
            .frame(width: 200, height: 60)
            .background(isValidGameID ? SwiftUI.Color(.green) : SwiftUI.Color(.gray).opacity(0.3))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            .disabled(!isValidGameID)
            
            Spacer()
            
            // Back button
            Button("Back") {
                path.removeLast()
            }
            .padding()
            .foregroundStyle(.white)
        }
    }
}
