//
//  JoinHostView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//

import SwiftUI

struct JoinHostView: View {
    
    @Binding var path: [Route]
    @Binding var coins: Int
    @Binding var gameID: String
    
    var body: some View {
        VStack {
            BalanceView(coins: $coins)
            
            Spacer()
            
            Button("Join Game") {
                gameID = "" // reset input
                path.append(.enterGameID)
            }
            .font(.title)
            .buttonStyle(.borderedProminent)
            
            Button("Host Game") {
                path.append(.gameSelectMP)
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
