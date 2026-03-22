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
    //case playBlackjack
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
    
    // Roulette wheel variables
    @State private var wheel = RouletteWheel()
    @State private var rotation: Double = 0
    @State private var winningPocket: RoulettePocket? = nil
    
    // Selected game
    @State private var selectedGame: Game? = nil
    
    // Number of players
    @State private var selectedPlayerCount: Int? = nil
    
    // Number of CPUs
    @State private var selectedCPUCount: Int? = nil
    
    // The game ID the user enters to join a game
    @State private var gameID: String = ""
    
    // State variable which will display the table of bets
    @State private var showingBetSheet = false
    
    // List of available CPUs based on the selected number of players during multiplayer select (host)
    var availableCPUOptions: [Int] {
        guard let humans = selectedPlayerCount else { return [] }
        return Array(0...(maxPlayers - humans))
    }
    
    // Boolean which determines if the user enters a valid game ID
    var isValidGameID: Bool {
        gameID.count == 3 && gameID.allSatisfy { $0.isNumber }
    }
    
    // Bets selected for roulette single player
    @State private var selectedNumberBets: Set<Int> = []
    
    // Initial player balance before a game is played
    @State private var startingCoins: Int = 0
    
    // Initialize stored variables
    @AppStorage("playerName") var playerName: String = ""
    @AppStorage("coins") var coins: Int = 0
    
    // View which displays the player's current balance
    var balanceView: some View {
        VStack {
            Text("Balance: \(coins)")
                .font(.title2)
                .padding(.top)
        }
    }
    
    // View which contains a button for the user to claim their daily balance
    var claimBonusView: some View {
        VStack {
            Button("CLAIM DAILY BONUS") {
                coins += 1000
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    // Main menu
    var mainMenuView: some View {
        VStack {
            balanceView
            claimBonusView

            Spacer()

            Button("PLAY") {
                currentScreen = .playSelect
            }
            .font(.largeTitle)
            .frame(width: 200, height: 100)
            .background(SwiftUI.Color(.blue))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))

            Spacer()

            HStack {
                Button {
                    currentScreen = .settings
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.title)
                }

                Spacer()

                Button {
                    currentScreen = .profile
                } label: {
                    Image(systemName: "person.circle.fill")
                        .font(.title)
                }
            }
            .padding()
        }
    }
    
    // Single-player/multiplayer selection screen
    var playSelectView: some View {
        VStack {
            balanceView

            Spacer()

            Button("SINGLEPLAYER") {
                currentScreen = .gameSelectSP
            }
            .font(.title)
            .buttonStyle(.borderedProminent)

            Button("MULTIPLAYER") {
                currentScreen = .joinHost
            }
            .font(.title)
            .buttonStyle(.borderedProminent)

            Spacer()

            Button("Back") {
                currentScreen = .mainMenu
            }
            .padding()
        }
    }
    
    // Game selection screen for single player
    var gameSelectSPView: some View {
        VStack {
            balanceView
            
            Spacer()
            Text("Which game would you like to play?")
                .font(.title2)
            Button("Roulette") {
                currentScreen = .CPUSelect
                selectedGame = .roulette
            }
            .font(.title)
            .buttonStyle(.borderedProminent)
            
            Button("Blackjack") {
                currentScreen = .CPUSelect
                selectedGame = .blackjack
            }
            .font(.title)
            .buttonStyle(.borderedProminent)
            
            Spacer()

            Button("Back") {
                currentScreen = .playSelect
            }
            .padding()
        }
    }
    
    // Number of CPUs selection screen
    var CPUSelectView: some View {
        VStack {
            balanceView
            
            Spacer()
            
            Text("Select Number of CPUs")
                .font(.title2)
            
            HStack {
                ForEach(1...maxPlayers, id: \.self) { num in
                    Button("\(num)") {
                        selectedCPUCount = num
                    }
                    .frame(width: 60, height: 60)
                    .background(selectedCPUCount == num ? SwiftUI.Color.blue : SwiftUI.Color.gray.opacity(0.3))
                    .foregroundColor(.white)
                    .clipShape(Circle())
                }
            }
            .padding()
            
            Spacer()
            
            Button("PLAY") {
                if (selectedGame == .roulette) {
                    currentScreen = .playRoulette
                    startingCoins = coins
                }
                else if (selectedGame == .blackjack) {
                    // TODO: Proceed to blackjack
                }
            }
            .font(.title)
            .buttonStyle(.borderedProminent)
            .disabled(selectedCPUCount == nil)
            
            Spacer()
            
            Button("Back") {
                currentScreen = .gameSelectSP
                selectedGame = nil
                selectedCPUCount = nil
            }
            .padding()
        }
    }
    
    // Join/host selection screen for multiplayer
    var joinHostView: some View {
        VStack {
            balanceView
            
            Spacer()
            
            Button("Join Game") {
                gameID = "" // reset input
                currentScreen = .enterGameID
            }
            .font(.title)
            .buttonStyle(.borderedProminent)
            
            Button("Host Game") {
                currentScreen = .gameSelectMP
            }
            .font(.title)
            .buttonStyle(.borderedProminent)
            
            Spacer()

            Button("Back") {
                currentScreen = .playSelect
            }
            .padding()
        }
    }
    
    // Game ID input screen for multiplayer
    var enterGameIDView: some View {
        VStack {
            balanceView
            
            Spacer()
            
            Text("Enter Game ID")
                        .font(.title2)
                    
                    TextField("3-digit ID", text: $gameID)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 150)
                        .multilineTextAlignment(.center)
                        .onChange(of: gameID) {
                            // Restrict to digits and max length of 3
                            gameID = String(gameID.filter { $0.isNumber }.prefix(3))
                        }
                    
                    Spacer()
                    
                    Button("JOIN") {
                        if isValidGameID {
                            currentScreen = .waitingRoom
                        }
                    }
                    .font(.title)
                    .frame(width: 200, height: 60)
                    .background(isValidGameID ? SwiftUI.Color(.green) : SwiftUI.Color(.gray).opacity(0.3))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                    .disabled(!isValidGameID)
            
            Spacer()
            
            Button("Back") {
                currentScreen = .joinHost
            }
        }
    }
    
    // Game selection and options screen for multiplayer
    var gameSelectMPView: some View {
        VStack {
            balanceView
            
            Spacer()
            
            Text("Select game to host")
                .font(.title2)
            Button("Roulette") {
                selectedGame = .roulette
            }
            .font(.title)
            .frame(width: 150, height: 50)
            .background(selectedGame == .roulette ? SwiftUI.Color(.blue) : SwiftUI.Color(.gray).opacity(0.3))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            
            Button("Blackjack") {
                selectedGame = .blackjack
            }
            .font(.title)
            .frame(width: 150, height: 50)
            .background(selectedGame == .blackjack ? SwiftUI.Color(.blue) : SwiftUI.Color(.gray).opacity(0.3))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            
            Spacer()
            
            VStack(spacing: 20) {
                
                // Human Players Picker
                VStack {
                    Text("Number of Human Players")
                        .font(.headline)
                    
                    Picker("Humans", selection: $selectedPlayerCount) {
                        Text("Select").tag(Int?.none)
                        ForEach(1...maxHumans, id: \.self) { num in
                            Text("\(num)").tag(Optional(num))
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                // CPU Players Picker
                VStack {
                    Text("Number of CPUs")
                        .font(.headline)
                    
                    Picker("CPUs", selection: $selectedCPUCount) {
                        Text("Select").tag(Int?.none)
                        ForEach(availableCPUOptions, id: \.self) { num in
                            Text("\(num)").tag(Optional(num))
                        }
                    }
                    .pickerStyle(.menu)
                    .disabled(selectedPlayerCount == nil)
                }
            }
            .padding()
            
            Spacer()
            
            Button("Launch Game") {
                if (selectedGame != nil &&
                    selectedPlayerCount != nil &&
                    selectedCPUCount != nil) {
                    currentScreen = .waitingRoom
                }
            }
            .font(.title)
            .frame(width: 200, height: 100)
            .background((selectedGame != nil &&
                        selectedPlayerCount != nil &&
                        selectedCPUCount != nil)
                        ? SwiftUI.Color(.red) : SwiftUI.Color(.gray).opacity(0.3))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            
            Spacer()
            
            Button("Back") {
                currentScreen = .joinHost
                selectedGame = nil
                selectedPlayerCount = nil
                selectedCPUCount = nil
            }
        }
    }
    
    // Waiting room screen for multiplayer
    var waitingRoomView: some View {
        VStack {
            balanceView
            
            Spacer()
            
            Text("Waiting Room")
            Button("Start Game") {
                if (selectedGame == .roulette) {
                    currentScreen = .playRoulette
                    startingCoins = coins
                }
                else if (selectedGame == .blackjack) {
                    // TODO: Proceed to blackjack
                }
            }
            .font(.title)
            .frame(width: 150, height: 100)
            .background((selectedGame != nil &&
                        selectedPlayerCount != nil &&
                        selectedCPUCount != nil)
                        ? SwiftUI.Color(.blue) : SwiftUI.Color(.gray).opacity(0.3))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            
            Spacer()
            
            Button("Leave Room") {
                currentScreen = .mainMenu
                selectedGame = nil
                selectedPlayerCount = nil
                selectedCPUCount = nil
            }
        }
    }
    
    // Settings screen (nothing to display for now)
    var settingsView: some View {
        VStack {
            balanceView
            Spacer()
            Text("Settings Screen")
            Spacer()
            Button("Back") {
                currentScreen = .mainMenu
            }
        }
    }

    // Profile screen (nothing for now, will be used to display login and authentication information)
    var profileView: some View {
        VStack {
            balanceView
            Spacer()
            Text("Profile Screen")
            Spacer()
            Button("Back") {
                currentScreen = .mainMenu
            }
        }
    }
    
    // Roulette game screen
    // Initially, the wheel will be visible
    // The user can click on "BET" to display the table of bets
    var rouletteView: some View {
        
        VStack {
            balanceView
            Spacer()

            
            ZStack {
                
                // Your existing roulette UI
                VStack {
                    ZStack {
                        // Wheel
                        RouletteWheelView(wheel: wheel, rotation: $rotation)
                            .frame(width: 250, height: 250)
                        
                        Circle()
                            .stroke(SwiftUI.Color.black, lineWidth: 2)
                            .fill(SwiftUI.Color.yellow)
                            .frame(width: 175, height: 175)
                            .shadow(radius: 2)
                        
                        // Result text
                        if let pocket = winningPocket {
                            Text("Result: \(pocket.displayNumber)")
                                .font(.headline)
                        } else {
                            Text("Tap to Spin")
                                .font(.headline)
                        }
                            
                    }
                    .onTapGesture {
                        spinWheel()
                    }

                    Button("BET") {
                        withAnimation {
                            showingBetSheet = true
                        }
                    }
                    .padding()
                }

                // Overlay (only shows when betting)
                if showingBetSheet {
                    SwiftUI.Color(.black).opacity(0.4)
                        .ignoresSafeArea()
                        .transition(.opacity)
                }

                if showingBetSheet {
                    betSheetView
                        .transition(.move(edge: .bottom))
                }
            }

            
            Spacer()
            Button("Leave") {
                currentScreen = .finish
            }
        }
        
    }
    
    // Table of bets display
    var betSheetView: some View {
        VStack {
            Spacer()

            VStack(spacing: 16) {

                Text("Place Your Bets")
                    .font(.headline)
                    .padding()

                // Table of bets
                ScrollView {
                    TableOfBets(
                        selectedBets: $selectedNumberBets,
                        coins: $coins,
                        betAmount: betAmount
                    )
                }

                // Button to return to the wheel
                Button("WHEEL") {
                    withAnimation {
                        showingBetSheet = false
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(SwiftUI.Color(.green))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)

            }
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity)
            .background(SwiftUI.Color(.white))
            .cornerRadius(20)
            .shadow(radius: 10)
        }
        .ignoresSafeArea()
    }
    
    // TODO: Add view for blackjack
    
    // Compute the players winnings/losses
    var netWinnings: Int {
        coins - startingCoins
    }
    
    // Finished screen after a game has ended
    var gameFinishedView: some View {
        VStack {
            balanceView
            Spacer()
            
            // Display the player winnings/losses
            if netWinnings > 0 {
                Text("You won: +\(netWinnings)")
                    .font(.title)
                    .foregroundColor(.green)
            }
            else if netWinnings < 0 {
                Text("You lost: \(netWinnings)")
                    .font(.title)
                    .foregroundColor(.red)
            }
            else {
                Text("No change in your balance")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            Button("Leave") {
                currentScreen = .mainMenu
                selectedGame = nil
                selectedPlayerCount = nil
                selectedCPUCount = nil
            }
        }
    }
    
    // State machine to display the correct screen
    var body: some View {
        switch currentScreen {
        case .mainMenu:
            mainMenuView
        case .playSelect:
            playSelectView
        case .settings:
            settingsView
        case .profile:
            profileView
        case .gameSelectSP:
            gameSelectSPView
        case .CPUSelect:
            CPUSelectView
        case .joinHost:
            joinHostView
        case .enterGameID:
            enterGameIDView
        case .gameSelectMP:
            gameSelectMPView
        case .waitingRoom:
            waitingRoomView
        case .playRoulette:
            rouletteView
        //case .playBlackjack:
            //BlackjackView
        case .finish:
            gameFinishedView
        }
    }
    
    // Helper function to spin the roulette wheel (potentially move to RouletteWheel.swift (?))
    func spinWheel() {
        let result = wheel.spinWithIndex()
        winningPocket = result.pocket

        let sliceAngle = 360.0 / Double(wheel.pockets.count)
        let winningAngle = sliceAngle * Double(result.index)

        rotation += 360 * 5 + (360 - winningAngle)
        
        // Payout
        if let winningNumber = Int(result.pocket.displayNumber) {
            if selectedNumberBets.contains(winningNumber) {
                coins += betAmount * 2
            }
        }
        
        // Clear the bets after the wheel is spun
        selectedNumberBets.removeAll()
    }
}

struct BlackjackView: View {
    
    @State private var dealer = BlackjackDealer(deck: Deck())

    
    var body: some View {
        Text(dealer.toString())
        
    }
}

#Preview {
    ContentView()
}
