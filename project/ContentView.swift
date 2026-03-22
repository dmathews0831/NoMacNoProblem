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

struct ContentView: View {

    // State variable which controls which screen is being displayed
    @State private var currentScreen: Screen = .mainMenu
    
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
    
    var availableCPUOptions: [Int] {
        guard let humans = selectedPlayerCount else { return [] }
        return Array(0...(maxPlayers - humans))
    }
    
    // Boolean which determines if the user enters a valid game ID
    var isValidGameID: Bool {
        gameID.count == 3 && gameID.allSatisfy { $0.isNumber }
    }
    
    // Initialize stored variables
    @AppStorage("playerName") var playerName: String = ""
    @AppStorage("coins") var coins: Int = 0
    
    var balanceView: some View {
        VStack {
            Text("Balance: \(coins)")
                .font(.title2)
                .padding(.top)
        }
    }
    
    var claimBonusView: some View {
        VStack {
            Button("CLAIM DAILY BONUS") {
                coins += 1000
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
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
    
    var waitingRoomView: some View {
        VStack {
            balanceView
            
            Spacer()
            
            Text("Waiting Room")
            Button("Start Game") {
                if (selectedGame == .roulette) {
                    currentScreen = .playRoulette
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
    
    var rouletteView: some View {
        VStack {
            balanceView
            Spacer()
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

            
            Spacer()
            Button("Leave") {
                currentScreen = .finish
            }
        }
        
    }
    
    var gameFinishedView: some View {
        VStack {
            balanceView
            Spacer()
            
            Text("You won: $0.00")  // TODO: Implement earnings/losses
            
            Spacer()
            Button("Leave") {
                currentScreen = .mainMenu
                selectedGame = nil
                selectedPlayerCount = nil
                selectedCPUCount = nil
            }
        }
    }
    
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
    
    func spinWheel() {
        let result = wheel.spinWithIndex()
        winningPocket = result.pocket

        let sliceAngle = 360.0 / Double(wheel.pockets.count)
        let winningAngle = sliceAngle * Double(result.index)

        // Spin multiple times + land on correct slice
        rotation += 360 * 5 + (360 - winningAngle)
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
