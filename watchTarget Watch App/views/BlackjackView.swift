//
//  BlackjackView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 4/4/26.
//

import SwiftUI

struct BlackjackView: View {
    
    @Binding var path: [Route]
    @Binding var coins: Int
    @Binding var dealer: BlackjackDealer
    @Binding var betAmount: Double
    @Binding var dealerHand: [PlayingCard]
    @Binding var playerHand: [PlayingCard]
    @Binding var dealerScore: Int
    @Binding var playerScore: Int
    
    func startGame() {
        dealer.takeBet(amount: Int(betAmount))
        coins -= Int(betAmount)
        dealer.newDeck()

        // Deal initial cards
        playerHand.append(dealer.dealCard()!)
        dealerHand.append(dealer.dealCard()!)
        playerHand.append(dealer.dealCard()!)
        let hiddenCard = dealer.dealCard()!
        hiddenCard.hide()
        dealerHand.append(hiddenCard)

        updateScores()
    }

    func updateScores() {
        let score = dealer.assessHands(playerHand: playerHand, dealerHand: dealerHand)
        playerScore = score.0
        dealerScore = score.1
    }
    
    var body: some View {
        VStack {
            Text("Balance: \(coins)")
                .font(.headline)
            
            Spacer()
            
            Text("Bet: \(Int(betAmount))")
            // Replace with .digitalCrownRotation on watchOS
            Slider(value: $betAmount, in: 10...Double(max(coins, 10)), step: 10)
            
            Button("Deal") {
                startGame()
                path.append(.blackjackGame)
            }
            .disabled(coins < 10)
        }
    }
}
