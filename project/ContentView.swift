//
//  ContentView.swift
//  project
//
//  Created by Dylan Mathews on 2/9/26.
//

import SwiftUI
import Foundation

// Screen states for the UI
enum Screen {
    case mainMenu
    case playSelect
    case settings
    case profile
    case gameSelectSP
    case joinHost
    case gameSelectMP
    case CPUSelect
    case enterGameID
    case waitingRoom
    case playRoulette
    case playBlackjack
    case finish
    
}

enum Route: Hashable {
    case mainMenu
    case playSelect
    case settings
    case profile
    case gameSelectSP
    case joinHost
    case gameSelectMP
    case CPUSelect
    case enterGameID
    case waitingRoom
    case playRoulette
    case playBlackjack
    case finish
}

// Game states
enum Game {
    case roulette
    case blackjack
}

// Maximum number of possible CPUs in a game
let maxPlayers = 4

// Maximum number of possible human players in a game
let maxHumans = 4

// Default bet amount
let betAmount = 10

struct ContentView: View {

    // State variable which controls which screen is being displayed
    @State private var currentScreen: Screen = .mainMenu
    
    @State private var path: [Route] = [];
    
    // Selected game
    @State private var selectedGame: Game? = nil
    
    // Number of players
    @State private var selectedPlayerCount: Int? = nil
    
    // Number of CPUs
    @State private var selectedCPUCount: Int? = nil
    
    // The game ID the user enters to join a game
    @State private var gameID: String = ""
    
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
    
    // Initial player balance before a game is played
    @State private var startingCoins: Int = 0
    
    // Initialize stored variables
    @AppStorage("playerName") var playerName: String = ""
    @AppStorage("coins") var coins: Int = 0
    
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
    
    var BlackjackView: some View {
        
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
    
    var body: some View {
        NavigationStack(path: $path) {
            MainMenuView(path: $path, coins: $coins)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .mainMenu:
                        MainMenuView(path: $path, coins: $coins)
                    case .playSelect:
                        PlaySelectView(path: $path, coins: $coins)
                    case .settings:
                        SettingsView(path: $path)
                    case .profile:
                        ProfileView(path: $path)
                    case .gameSelectSP:
                        GameSelectSPView(path: $path, coins: $coins, selectedGame: $selectedGame)
                    case .CPUSelect:
                        CPUSelectView(path: $path, coins: $coins, selectedGame: $selectedGame, selectedPlayerCount: $selectedPlayerCount, selectedCPUCount: $selectedCPUCount, startingCoins: $startingCoins)
                    case .joinHost:
                        JoinHostView(path: $path, coins: $coins, gameID: $gameID)
                    case .enterGameID:
                        EnterGameIDView(path: $path, coins: $coins, selectedGame: $selectedGame, gameID: $gameID)
                    case .gameSelectMP:
                        GameSelectMPView(path: $path, coins: $coins, selectedGame: $selectedGame, selectedPlayerCount: $selectedPlayerCount, selectedCPUCount: $selectedCPUCount)
                    case .waitingRoom:
                        WaitingRoomView(path: $path, coins: $coins, selectedGame: $selectedGame, selectedPlayerCount: $selectedPlayerCount, selectedCPUCount: $selectedCPUCount, startingCoins: $startingCoins)
                    case .playRoulette:
                        RouletteView(path: $path, coins: $coins)
                    case .playBlackjack:
                        BlackjackView
                    case .finish:
                        GameFinishedView(path: $path, coins: $coins, startingCoins: $startingCoins, selectedGame: $selectedGame, selectedPlayerCount: $selectedPlayerCount, selectedCPUCount: $selectedCPUCount)
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
