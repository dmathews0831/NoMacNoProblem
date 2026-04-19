//
//  RouletteView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//

import SwiftUI

struct RouletteView: View {
    
    @Binding var path: [Route]
    @Binding var coins: Int
    
    // Current bets
    @State private var bets: [BetType: Int] = [:]
    
    // Current amount the player wants to bet with
    @State private var currentBetAmount: Int = 10
    
    // Roulette wheel variables
    @State private var wheel = RouletteWheel()
    @State private var rotation: Double = 0
    @State private var winningPocket: RoulettePocket? = nil
    
    // State variable which will display the table of bets
    @State private var showingBetSheet = false
    
    @State var isWheelSpinning: Bool = false
    
    let redNumbers: Set<Int> = [
        1,3,5,7,9,
        12,14,16,18,
        19,21,23,25,27,
        30,32,34,36
    ]
    
    var body: some View {
        VStack {
            BalanceView(coins: $coins)
            Spacer()
            ZStack {
                VStack {
                    ZStack {
                        Circle()
                            .stroke(.black, lineWidth: 2)
                            .frame(width: 300, height: 300)
                            .shadow(radius: 50)
                        // Wheel
                        RouletteWheelView(rotation: $rotation, wheel: wheel)
                            .frame(width: 300, height: 300)
                        // Center of wheel
                        Circle()
                            .stroke(SwiftUI.Color.black, lineWidth: 2)
                            .fill(SwiftUI.Color.yellow)
                            .frame(width: 175, height: 175)
                            .shadow(radius: 2)
                        // Result text
                        if let pocket = winningPocket {
                            Text("Result: \(pocket.displayNumber)")
                                .font(.headline)
                        }
                        else {
                            Text("Tap to Spin")
                                .font(.headline)
                        }
                        
                    }
                    .onTapGesture {
                        if !isWheelSpinning {
                            spinWheel()
                            //isWheelSpinning = true
                        }
                    }
                    // Button to pull up the bet table
                    Button("BET") {
                        withAnimation {
                            showingBetSheet = true
                        }
                    }
                    .font(.title)
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    .foregroundStyle(.white)
                    .padding()
                }
                if showingBetSheet {
                    // Dim the background
                    SwiftUI.Color(.black).opacity(0.4)
                        .ignoresSafeArea()
                        .transition(.opacity)
                    
                    // Bet sheet
                    BetSheetView(
                        coins: $coins,
                        bets: $bets,
                        currentBetAmount: $currentBetAmount,
                        showingBetSheet: $showingBetSheet
                    )
                    .transition(.move(edge: .bottom))
                }
            }
            Spacer()
            // Leave button
            Button("Leave") {
                path.append(.finish)
            }
            .foregroundStyle(.white)
        }
    }
    
    // Helper function to spin the roulette wheel
    func spinWheel() {
        let result = wheel.spinWithIndex()
        winningPocket = result.pocket

        let sliceAngle = 360.0 / Double(wheel.pockets.count)
        let winningAngle = sliceAngle * Double(result.index)

        rotation += 360 * 5 + (360 - winningAngle)
        
        if let winningNumber = Int(result.pocket.displayNumber) {
            payout(for: winningNumber)
        }
    }
    
    // Hepler function to determine the payout based on the player's bets
    func payout(for winningNumber: Int) {
        for (bet, amount) in bets {
            switch bet {
            case .number(let num):
                if num == winningNumber {
                    coins += amount * 36
                }
            case .zero:
                if winningNumber == 0 {
                    coins += amount * 36
                }
            case .doubleZero:
                if winningNumber == -1 {
                    coins += amount * 36
                }
            case .even:
                if winningNumber != 0 && winningNumber % 2 == 0 {
                    coins += amount * 2
                }
            case .odd:
                if winningNumber % 2 == 1 {
                    coins += amount * 2
                }
            case .red:
                if redNumbers.contains(winningNumber) {
                    coins += amount * 2
                }
            case .black:
                if !redNumbers.contains(winningNumber) && winningNumber != 0 {
                    coins += amount * 2
                }

            case .low:
                if (1...18).contains(winningNumber) {
                    coins += amount * 2
                }
            case .high:
                if (19...36).contains(winningNumber) {
                    coins += amount * 2
                }
            case .dozen(let d):
                if (((d - 1) * 12 + 1)...(d * 12)).contains(winningNumber) {
                    coins += amount * 3
                }
            case .column(let c):
                if winningNumber != 0 && winningNumber % 3 == c % 3 {
                    coins += amount * 3
                }
            }
        }

        // Reset all bets
        bets.removeAll()
    }
}
