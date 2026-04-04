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
    
    // State variable for the blackjack dealer object
    @State private var dealer = BlackjackDealer(deck: Deck())
    
    // State varibale for the blackjack bet amount
    @State private var betAmountB: Double = 10
    
    // State variable for the player
    // Placeholder constructor values, add data persistence later
    @State private var player: Player = Player(id: 1, balance: 0)
    
    // State variable to track if a blackjack game is active
    @State private var isBlackjackActive = false
    
    // State variables to track current hands in blackjack
    @State private var dealerHand: [PlayingCard] = []
    @State private var playerHand: [PlayingCard] = []
    
    // State variables for the scores in blackjack
    @State private var dealerScore: Int = 0
    @State private var playerScore: Int = 0
    
    // State variable for the ending message in blackjack
    @State private var blackjackEndMessage: String = ""
    
    // Resets blackjack
    func resetBlackjack() {
        sleep(3)
        betAmountB = 10
        dealer.betAmount = 0
        dealer.newDeck()
        playerHand = []
        dealerHand = []
        playerScore = 0
        dealerScore = 0
    }
    
    // Takes a turn for the blackjack dealer
    func dealerTurn() {
        updateScores()
        
        let gameState = dealer.checkGameState(
            playerScore: playerScore,
            dealerScore: dealerScore,
            stand: true
        )
        
        if !gameState.2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                dealerHand.append(dealer.dealCard()!)
                dealerTurn()
            }
        } else {
            endGame(gameState: gameState)
        }
    }
    
    // End-game logic for blackjack
    func endGame(gameState: (Bool, Bool, Bool)) {
        isBlackjackActive = false
        
        if gameState.0 {
            coins += 2 * dealer.betAmount
            blackjackEndMessage = "You Win! (+\(dealer.betAmount))"
        } else if gameState.1 {
            coins += dealer.betAmount
            blackjackEndMessage = "Push!"
        } else {
            blackjackEndMessage = "You Lose! (-\(dealer.betAmount))"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            resetBlackjack()
        }
    }
    
    // Update blackjack score logic
    func updateScores() {
        let score = dealer.assessHands(
            playerHand: playerHand,
            dealerHand: dealerHand
        )
        dealerScore = score.1
        playerScore = score.0
    }
    
    var body: some View {
        
        VStack {
            Text("Balance: \(coins)")
            Text(blackjackEndMessage)
            VStack {
                Text("Dealer: \(dealerScore)")
                HStack {
                    ForEach(dealerHand) { card in
                        Text(card.description())
                            .padding(8)
                        //.background(Color.white)
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
                            .padding(8)
                        //.background(Color.white)
                            .cornerRadius(6)
                    }
                }
            }
            
            
            Spacer()
            
            Text("Bet: \(Int(betAmountB))")
            
            Button("Hit") {
                playerHand.append(dealer.dealCard()!)
                updateScores()
                var gameState = dealer.checkGameState(playerScore: playerScore, dealerScore: dealerScore, stand: false)
                if gameState.2 {
                    resetBlackjack()
                    blackjackEndMessage = "You Lose! (-\(dealer.betAmount))"
                }
            }
            .disabled(!isBlackjackActive)
            Button("Stand") {
                isBlackjackActive = false
                dealerHand[1].hide()
                dealerTurn()
            }
            .disabled(!isBlackjackActive)
            Button("Double") {
                isBlackjackActive = false
                dealer.takeBet(amount: Int(betAmountB))
                coins -= Int(betAmountB)
                playerHand.append(dealer.dealCard()!)
                updateScores()
                var gameState = dealer.checkGameState(playerScore: playerScore, dealerScore: dealerScore, stand: true)
                if gameState.2 {
                    endGame(gameState: gameState)
                    return
                }
                dealerHand[1].hide()
                dealerTurn()
            }
            .disabled(!isBlackjackActive || coins < Int(betAmountB))
            
            Slider(value: $betAmountB, in: 10...Double(coins), step: 10).disabled(isBlackjackActive)
            
            Button("Play Game") {
                dealer.takeBet(amount: Int(betAmountB))
                coins -= Int(betAmountB)
                isBlackjackActive = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    playerHand.append(dealer.dealCard()!)
                    updateScores()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    dealerHand.append(dealer.dealCard()!)
                    updateScores()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    playerHand.append(dealer.dealCard()!)
                    updateScores()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    var dealerHiddenCard = dealer.dealCard()
                    dealerHiddenCard?.hide()
                    dealerHand.append(dealerHiddenCard!)
                }
                blackjackEndMessage = ""
            }
            .disabled(isBlackjackActive && blackjackEndMessage != "")
        }
    }
}
