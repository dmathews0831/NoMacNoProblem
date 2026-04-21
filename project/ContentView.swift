//
//  ContentView.swift
//  project
//
//  Created by Dylan Mathews on 2/9/26.
//
//  Description: This is the iOS version of our mobile casino app. This ContentView contains the main navigation stack for the app, allowing the player to navigation between the different screens.

import SwiftUI
import Foundation

// Navigation Stacks - Implements NavigationStack with Route enum for screen switching
// 5+ Tasks - MainMenu, PlaySelect, GameSelect, Roulette, Blackjack, Profile, Settings, Finish
// Data Binding - Uses @State for navigation, game state, and @AppStorage for persistence

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

// Functional Programming - Enum for type-safe game selection
enum Game {
    case roulette    // TASK 1: Play Roulette game
    case blackjack   // TASK 2: Play Blackjack game
}

// Maximum number of possible CPUs in a game
let maxPlayers = 4

// Maximum number of possible human players in a game
let maxHumans = 4

// Default bet amount
let betAmount = 10

// Custom Views - Uses custom MainMenuView, PlaySelectView, GameSelectSPView, etc.
// Data Binding - @State and @AppStorage for reactive state management
struct ContentView: View {
    
    // Data Binding - Navigation path for NavigationStack routing
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
    
    // Data Binding - @AppStorage for persistent data binding across app sessions
    @AppStorage("playerName") var playerName: String = ""
    @AppStorage("coins") var coins: Int = 0
    
    // Variable the user can set to change to dark mode
    @AppStorage("darkModeEnabled") var darkModeEnabled: Bool = true;
    
    var body: some View {
        // Navigation Stacks - Primary navigation using NavigationStack with path binding
        // Data Binding - Passes bindings to child views for reactive updates
        NavigationStack(path: $path) {
            MainMenuView(path: $path, coins: $coins)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .mainMenu:
                        MainMenuView(path: $path, coins: $coins)
                            .navigationBarBackButtonHidden(true)
                            .background(Image("CasinoBackground"))
                    case .playSelect:
                        PlaySelectView(path: $path, coins: $coins)
                            .navigationBarBackButtonHidden(true)
                            .background(Image("CasinoBackground"))
                    case .settings:
                        SettingsView(path: $path)
                            .navigationBarBackButtonHidden(true)
                            .background(Image("CasinoBackground"))
                    case .profile:
                        ProfileView(path: $path)
                            .navigationBarBackButtonHidden(true)
                            .background(Image("CasinoBackground"))
                    case .gameSelectSP:
                        GameSelectSPView(path: $path, coins: $coins, selectedGame: $selectedGame)
                            .navigationBarBackButtonHidden(true)
                            .background(Image("CasinoBackground"))
                    case .CPUSelect:
                        CPUSelectView(path: $path, coins: $coins, selectedGame: $selectedGame, selectedPlayerCount: $selectedPlayerCount, selectedCPUCount: $selectedCPUCount, startingCoins: $startingCoins)
                            .navigationBarBackButtonHidden(true)
                            .background(Image("CasinoBackground")) 
                    case .joinHost:
                        JoinHostView(path: $path, coins: $coins, gameID: $gameID)
                            .navigationBarBackButtonHidden(true)
                            .background(Image("CasinoBackground"))
                    case .enterGameID:
                        EnterGameIDView(path: $path, coins: $coins, selectedGame: $selectedGame, gameID: $gameID)
                            .navigationBarBackButtonHidden(true)
                            .background(Image("CasinoBackground"))
                    case .gameSelectMP:
                        GameSelectMPView(path: $path, coins: $coins, selectedGame: $selectedGame, selectedPlayerCount: $selectedPlayerCount, selectedCPUCount: $selectedCPUCount)
                            .navigationBarBackButtonHidden(true)
                            .background(Image("CasinoBackground"))
                    case .waitingRoom:
                        WaitingRoomView(path: $path, coins: $coins, selectedGame: $selectedGame, selectedPlayerCount: $selectedPlayerCount, selectedCPUCount: $selectedCPUCount, startingCoins: $startingCoins)
                            .navigationBarBackButtonHidden(true)
                            .background(Image("CasinoBackground"))
                    case .playRoulette:
                        RouletteView(path: $path, coins: $coins)
                            .navigationBarBackButtonHidden(true)
                            .background(Image("CasinoBackground"))
                    case .playBlackjack:
                        BlackjackView(path: $path, coins: $coins)
                            .navigationBarBackButtonHidden(true)
                            .background(Image("CasinoBackground"))
                    case .finish:
                        GameFinishedView(path: $path, coins: $coins, startingCoins: $startingCoins, selectedGame: $selectedGame, selectedPlayerCount: $selectedPlayerCount, selectedCPUCount: $selectedCPUCount)
                            .navigationBarBackButtonHidden(true)
                            .background(Image("CasinoBackground"))
                    }
                }
                .background(Image("CasinoBackground"))
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
