//
//  BlackjackGame.swift
//  watchTarget Watch App
//
//  Created by lending on 4/13/26.
//

import SwiftUI

struct BlackjackGameView: View {
    @Binding var path: [Route]
    @Binding var coins: Int
    @Binding var dealer: BlackjackDealer
    @Binding var dealerHand: [PlayingCard]
    @Binding var playerHand: [PlayingCard]
    @Binding var dealerScore: Int
    @Binding var playerScore: Int
    @Binding var resultMessage: String

    var body: some View {
        VStack {
            VStack {
                Text("Dealer: \(dealerScore)")
                HStack {
                    ForEach(dealerHand) { card in
                        Text(card.description())
                            .padding(3)
                            .cornerRadius(6)
                    }
                }
            }

            Spacer()

            VStack {
                Text("Player: \(playerScore)")
                HStack {
                    ForEach(playerHand) { card in
                        Text(card.description())
                            .padding(3)
                            .cornerRadius(6)
                    }
                }
            }

            Spacer()

            HStack {
                Button("Hit") { handleHit() }
                    .font(.footnote)
                Button("Stand") { handleStand() }
                    .font(.footnote)
                Button("Double") { handleDouble() }
                    .disabled(coins < dealer.betAmount)
                    .font(.footnote)
            }
        }
        .navigationBarBackButtonHidden(true) // Don't allow back during a hand
    }

    func updateScores() {
        let score = dealer.assessHands(playerHand: playerHand, dealerHand: dealerHand)
        playerScore = score.0
        dealerScore = score.1
    }

    func goToResult(message: String) {
        resultMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            path.append(.blackjackResult)
        }
    }

    func handleHit() {
        playerHand.append(dealer.dealCard()!)
        updateScores()
        let gameState = dealer.checkGameState(playerScore: playerScore, dealerScore: dealerScore, stand: false)
        if gameState.2 {
            goToResult(message: "You Lose! (-\(dealer.betAmount))")
        }
    }

    func handleStand() {
        dealerHand[1].hide() // reveal hidden card
        dealerTurn()
    }

    func handleDouble() {
        dealer.takeBet(amount: dealer.betAmount)
        coins -= dealer.betAmount
        playerHand.append(dealer.dealCard()!)
        updateScores()
        let gameState = dealer.checkGameState(playerScore: playerScore, dealerScore: dealerScore, stand: true)
        if gameState.2 {
            resolveGame(gameState: gameState)
            return
        }
        dealerHand[1].hide()
        dealerTurn()
    }

    func dealerTurn() {
        updateScores()
        let gameState = dealer.checkGameState(playerScore: playerScore, dealerScore: dealerScore, stand: true)
        if !gameState.2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                dealerHand.append(dealer.dealCard()!)
                dealerTurn()
            }
        } else {
            resolveGame(gameState: gameState)
        }
    }

    func resolveGame(gameState: (Bool, Bool, Bool)) {
        if gameState.0 {
            coins += 2 * dealer.betAmount
            goToResult(message: "You Win! (+\(dealer.betAmount))")
        } else if gameState.1 {
            coins += dealer.betAmount
            goToResult(message: "Push!")
        } else {
            goToResult(message: "You Lose! (-\(dealer.betAmount))")
        }
    }
}
