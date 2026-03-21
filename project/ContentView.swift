//
//  ContentView.swift
//  project
//
//  Created by Dylan Mathews on 2/9/26.
//

import SwiftUI

// Screen states for the UI
enum Screen {
    case mainMenu
    case playSelect
    case settings
    case profile
    case gameSelectSP
    case joinHost
    //case gameSelectMP
    
}

struct ContentView: View {

    // State variable which controls which screen is being displayed
    @State private var currentScreen: Screen = .mainMenu
    
    @State private var wheel = RouletteWheel()
    @State private var rotation: Double = 0
    @State private var winningPocket: RoulettePocket? = nil
    
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
            .buttonStyle(.borderedProminent)

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
            
            Button("Roulette") {
                // TODO: navigate to roulette
            }
            .font(.title)
            .buttonStyle(.borderedProminent)
            
            Button("Blackjack") {
                // TODO: navigate to CPU select
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
    
    var joinHostView: some View {
        VStack {
            balanceView
            
            Spacer()
            
            Button("Join Game") {
                // TODO: navigate to enter game ID
            }
            .font(.title)
            .buttonStyle(.borderedProminent)
            
            Button("Host Game") {
                // TODO: navigate to game select
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
        case .joinHost:
            joinHostView
        }
    }
    
    /**
    var body: some View {
        VStack {

            TextField("Enter name:", text: $playerName).textFieldStyle(.roundedBorder)
            Text("Coins: \(coins)")
            Button("Claim bonus") {
                
                coins += 1000
            }
            
            ZStack {
                // Wheel
                RouletteWheelView(wheel: wheel, rotation: $rotation)
                    .frame(width: 250, height: 250)
                
                Circle()
                    .stroke(SwiftUI.Color.black, lineWidth: 2)
                    .fill(SwiftUI.Color.yellow)
                    .frame(width: 175, height: 175)
                    .shadow(radius: 2)
                    
            }
            .onTapGesture {
                spinWheel()
            }
            

            // Result text
            if let pocket = winningPocket {
                Text("Result: \(pocket.displayNumber)")
                    .font(.headline)
            } else {
                Text("Tap to Spin")
                    .font(.headline)
            }
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
     */
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
