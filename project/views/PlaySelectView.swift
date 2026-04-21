//
//  PlaySelectView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//
//  Description: This file contains the view for selecting which whether to play single-player or multiplayer.

import SwiftUI

struct PlaySelectView: View {
    
    @Binding var path: [Route]
    @Binding var coins: Int
    
    var body: some View {
        VStack {
            BalanceView(coins: $coins)
            
            Spacer()
            
            // Single-player button
            Button("SINGLEPLAYER") {
                path.append(.gameSelectSP)
            }
            .font(.title)
            .buttonStyle(.borderedProminent)
            
            // Multiplayer button
            Button("MULTIPLAYER") {
                path.append(.joinHost)
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
