//
//  JoinHostView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//
//  Description: This file contains the view for joining/hosting a game for multiplayer.

import SwiftUI

struct JoinHostView: View {
    
    @Binding var path: [Route]
    @Binding var coins: Int
    @Binding var gameID: String
    
    var body: some View {
        VStack {
            BalanceView(coins: $coins)
            
            Spacer()
            
            // Join game button
            Button("Join Game") {
                gameID = "" // reset input
                path.append(.enterGameID)
            }
            .font(.title)
            .buttonStyle(.borderedProminent)
            
            // Host game button
            Button("Host Game") {
                path.append(.gameSelectMP)
            }
            .font(.title)
            .buttonStyle(.borderedProminent)
            
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
