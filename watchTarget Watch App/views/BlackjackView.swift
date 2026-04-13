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

    @State private var dealer = BlackjackDealer(deck: Deck())
    @State private var betAmount: Double = 10
    @State private var dealerHand: [PlayingCard] = []
    @State private var playerHand: [PlayingCard] = []
    @State private var dealerScore: Int = 0
    @State private var playerScore: Int = 0
    @State private var resultMessage: String = ""
    
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

    func resetBlackjack() {
        betAmount = 10
        dealer.betAmount = 0
        dealer.newDeck()
        playerHand = []
        dealerHand = []
        playerScore = 0
        dealerScore = 0
        resultMessage = ""
        // Pop back to this screen (removes result + game screens)
        path.removeLast(min(2, path.count))
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
        .navigationDestination(for: Route.self) { route in
            switch route {
            case .blackjackGame:
                BlackjackGameView(
                    path: $path,
                    coins: $coins,
                    dealer: $dealer,
                    dealerHand: $dealerHand,
                    playerHand: $playerHand,
                    dealerScore: $dealerScore,
                    playerScore: $playerScore,
                    resultMessage: $resultMessage
                )
            case .blackjackResult:
                BlackjackResultView(
                    path: $path,
                    coins: $coins,
                    resultMessage: resultMessage,
                    onPlayAgain: resetBlackjack
                )
            default:
                EmptyView()
            }
        }
    }
}
