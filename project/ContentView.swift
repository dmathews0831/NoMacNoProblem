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
    
    // Initialize stored variables
    @AppStorage("playerName") var playerName: String = ""
    @AppStorage("coins") var coins: Int = 0
    
    var body: some View {
        NavigationStack(path: $path) {
            MainMenuView(path: $path, coins: $coins)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .mainMenu:
                        MainMenuView(path: $path, coins: $coins)
                            .navigationBarBackButtonHidden(true)
                    case .playSelect:
                        PlaySelectView(path: $path, coins: $coins)
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
                    case .CPUSelect:
                        CPUSelectView(path: $path, coins: $coins, selectedGame: $selectedGame, selectedPlayerCount: $selectedPlayerCount, selectedCPUCount: $selectedCPUCount, startingCoins: $startingCoins)
                            .navigationBarBackButtonHidden(true)
                    case .joinHost:
                        JoinHostView(path: $path, coins: $coins, gameID: $gameID)
                            .navigationBarBackButtonHidden(true)
                    case .enterGameID:
                        EnterGameIDView(path: $path, coins: $coins, selectedGame: $selectedGame, gameID: $gameID)
                            .navigationBarBackButtonHidden(true)
                    case .gameSelectMP:
                        GameSelectMPView(path: $path, coins: $coins, selectedGame: $selectedGame, selectedPlayerCount: $selectedPlayerCount, selectedCPUCount: $selectedCPUCount)
                            .navigationBarBackButtonHidden(true)
                    case .waitingRoom:
                        WaitingRoomView(path: $path, coins: $coins, selectedGame: $selectedGame, selectedPlayerCount: $selectedPlayerCount, selectedCPUCount: $selectedCPUCount, startingCoins: $startingCoins)
                            .navigationBarBackButtonHidden(true)
                    case .playRoulette:
                        RouletteView(path: $path, coins: $coins)
                            .navigationBarBackButtonHidden(true)
                    case .playBlackjack:
                        BlackjackView(path: $path, coins: $coins)
                            .navigationBarBackButtonHidden(true)
                    case .finish:
                        GameFinishedView(path: $path, coins: $coins, startingCoins: $startingCoins, selectedGame: $selectedGame, selectedPlayerCount: $selectedPlayerCount, selectedCPUCount: $selectedCPUCount)
                            .navigationBarBackButtonHidden(true)
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
