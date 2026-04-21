//
//  PlaySelectView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//

import SwiftUI

struct PlaySelectView: View {
    
    @Binding var path: [Route]
    @Binding var coins: Int
    
    var body: some View {
        VStack {
            BalanceView(coins: $coins)
            
            Spacer()
            
            Button("SINGLEPLAYER") {
                path.append(.gameSelectSP)
            }
            .font(.title)
            .buttonStyle(.borderedProminent)
            
            Button("MULTIPLAYER") {
                path.append(.joinHost)
            }
            .font(.title)
            .buttonStyle(.borderedProminent)
            
            Spacer()
            
            Button("Back") {
                path.removeLast()
            }
            .padding()
            .foregroundStyle(.white)
        }
    }
}
