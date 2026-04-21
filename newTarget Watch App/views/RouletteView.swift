//
//  RouletteView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//
//  Description: This file contains the primary view for roulette. It allows the player to place bets on the table of bets and spin the roulette wheel to get a number. If the number falls under one of the placed bets, the user gets the appropriate payout. If not, the player gets nothing.

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
    
    // State variable to control when the wheel is spinning
    @State var isWheelSpinning: Bool = false
    
    // Numbers which should be colored red on the wheel and table of bets
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
                            .frame(width: 150, height: 150)
                            .shadow(radius: 50)
                        // Wheel
                        RouletteWheelView(rotation: $rotation, wheel: wheel)
                            .frame(width: 150, height: 150)
                        // Center of wheel
                        Circle()
                            .stroke(SwiftUI.Color.black, lineWidth: 2)
                            .fill(SwiftUI.Color.yellow)
                            .frame(width: 100, height: 100)
                            .shadow(radius: 2)
                        // Result text
                        if let pocket = winningPocket {
                            Text("Result: \(pocket.displayNumber)")
                                .font(.caption)
                                .foregroundStyle(.black)
                        }
                        else {
                            Text("Tap to Spin")
                                .font(.caption)
                                .foregroundStyle(.black)
                        }
                        
                    }
                    // FUNCTIONAL REQUIREMENT: The player should be able to spin the roulette wheel to get a random number
                    .onTapGesture {
                        if !isWheelSpinning {
                            spinWheel()
                            //isWheelSpinning = true
                        }
                    }
                    Spacer()
                    HStack {
                        // Button to pull up the bet table
                        Button("BET") {
                            withAnimation {
                                showingBetSheet = true
                            }
                        }
                        .padding()
                        
                        // Leave button
                        // FUNCTIONAL REQUIREMENT: The host should be able to end the game by clicking a “leave” button
                        Button("Leave") {
                            path.append(.mainMenu)
                        }
                        .foregroundColor(.red)
                    }
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
        }
    }
    
    // Helper function to spin the roulette wheel
    func spinWheel() {
        isWheelSpinning = true
                    
        Task {
            // Fetch new number every spin
            await wheel.loadData()
                            
            let result = wheel.spinWithIndex()
                            
            // Spin the wheel according to the winning pocket
            DispatchQueue.main.async {
                winningPocket = result.pocket
                
                let sliceAngle = 360.0 / Double(wheel.pockets.count)
                let targetAngle = Double(result.index) * sliceAngle
                
                rotation += 360 * 5 + (360 - targetAngle)
                
                // Payout
                if let winningNumber = Int(result.pocket.displayNumber) {
                    payout(for: winningNumber)
                }
                
                // Stop spinning after animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    isWheelSpinning = false
                }
            }
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
