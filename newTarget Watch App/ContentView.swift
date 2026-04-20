//
//  ContentView.swift
//  project
//
//  Created by Dylan Mathews on 2/9/26.
//

import SwiftUI
import Foundation

enum Route: Hashable {
    case mainMenu
    case settings
    case profile
    case gameSelectSP
    case playRoulette
    case playBlackjack
    case finish
    case blackjackGame
    case blackjackResult

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
    
    @State private var path: [Route] = [];
    
    // Selected game
    @State private var selectedGame: Game? = nil
    
    // Number of players
    @State private var selectedPlayerCount: Int? = nil
    
    // Number of CPUs
    @State private var selectedCPUCount: Int? = nil
    
    // The game ID the user enters to join a game
    @State private var gameID: String = ""
    
    // Initial player balance before a game is played
    @State private var startingCoins: Int = 0
    
    // State variables for blackjack
    @State private var bjDealer = BlackjackDealer(deck: Deck())
    @State private var bjBetAmount: Double = 10
    @State private var bjDealerHand: [PlayingCard] = []
    @State private var bjPlayerHand: [PlayingCard] = []
    @State private var bjDealerScore: Int = 0
    @State private var bjPlayerScore: Int = 0
    @State private var bjResultMessage: String = ""
    
    // Initialize stored variables
    @AppStorage("playerName") var playerName: String = ""
    @AppStorage("coins") var coins: Int = 0
    
    func resetBlackjack() {
        bjBetAmount = 10
        bjDealer.betAmount = 0
        bjDealer.newDeck()
        bjPlayerHand = []
        bjDealerHand = []
        bjPlayerScore = 0
        bjDealerScore = 0
        bjResultMessage = ""
        path.removeLast(min(2, path.count))
    }
    
    var body: some View {
        ZStack {
            Image("CasinoBackground")
                .frame(width: 10, height: 10)
            // Main navigation stack for switching between screens
            NavigationStack(path: $path) {
                MainMenuView(path: $path, coins: $coins)
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .mainMenu:
                            MainMenuView(path: $path, coins: $coins)
                                .navigationBarBackButtonHidden(true)
                        case .settings:
                            SettingsView(path: $path)
                                .navigationBarBackButtonHidden(true)
                        case .profile:
                            ProfileView(path: $path)
                                .navigationBarBackButtonHidden(true)
                        case .gameSelectSP:
                            GameSelectSPView(path: $path, coins: $coins, selectedGame: $selectedGame)
                                .navigationBarBackButtonHidden(true)
                        case .playRoulette:
                            RouletteView(path: $path, coins: $coins)
                                .navigationBarBackButtonHidden(true)
                        case .playBlackjack:
                            BlackjackView(path: $path,
                                          coins: $coins,
                                          dealer: $bjDealer,
                                          betAmount: $bjBetAmount,
                                          dealerHand: $bjDealerHand,
                                          playerHand: $bjPlayerHand,
                                          dealerScore: $bjDealerScore,
                                          playerScore: $bjPlayerScore)
                            .navigationBarBackButtonHidden(true)
                        case .finish:
                            GameFinishedView(path: $path, coins: $coins, startingCoins: $startingCoins, selectedGame: $selectedGame, selectedPlayerCount: $selectedPlayerCount, selectedCPUCount: $selectedCPUCount)
                                .navigationBarBackButtonHidden(true)
                        case .blackjackGame:
                            BlackjackGameView(
                                path: $path,
                                coins: $coins,
                                dealer: $bjDealer,
                                dealerHand: $bjDealerHand,
                                playerHand: $bjPlayerHand,
                                dealerScore: $bjDealerScore,
                                playerScore: $bjPlayerScore,
                                resultMessage: $bjResultMessage
                            )
                            .navigationBarBackButtonHidden(true)
                        case .blackjackResult:
                            BlackjackResultView(
                                path: $path,
                                coins: $coins,
                                resultMessage: $bjResultMessage,
                                onPlayAgain: resetBlackjack
                            )
                            .navigationBarBackButtonHidden(true)
                        }
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}

/**
 
 Background image from:
 
 https://www.istockphoto.com/vector/poker-table-background-in-green-color-gm1441236934-480999711
 
 */
