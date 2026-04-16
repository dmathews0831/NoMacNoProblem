//
//  BlackjackResults.swift
//  watchTarget Watch App
//
//  Created by lending on 4/13/26.
//

import SwiftUI

struct BlackjackResultView: View {
    @Binding var path: [Route]
    @Binding var coins: Int
    @Binding var resultMessage: String
    let onPlayAgain: () -> Void

    var body: some View {
        VStack {
            Spacer()

            Text(resultMessage)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text("Balance: \(coins)")
                .font(.headline)
                .padding(.top, 8)

            Spacer()

            Button("Play Again") {
                onPlayAgain() // resets state and pops back to bet screen
            }

            Button("Quit") {
                path.removeAll() // pops all the way out
            }
            .foregroundColor(.red)
        }
        .navigationBarBackButtonHidden(true)
    }
}
