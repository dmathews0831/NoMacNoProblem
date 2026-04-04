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
    
    // Roulette wheel variables
    @State private var wheel = RouletteWheel()
    @State private var rotation: Double = 0
    @State private var winningPocket: RoulettePocket? = nil
    
    // State variable which will display the table of bets
    @State private var showingBetSheet = false
    
    // Bets selected for roulette single player
    @State private var selectedNumberBets: Set<Int> = []
    
    // Even/odd bet
    @State private var isEvenBetSelected: Bool = false
    @State private var isOddBetSelected: Bool = false
    
    //Color bets
    @State private var isRedBetSelected: Bool = false
    @State private var isBlackBetSelected: Bool = false
    
    // Range bets
    @State private var is1to18BetSelected: Bool = false
    @State private var is19to36BetSelected: Bool = false
    @State private var is1st12BetSelected: Bool = false
    @State private var is2nd12BetSelected: Bool = false
    @State private var is3rd12BetSelected: Bool = false
    
    // 0 bet
    @State private var is0BetSelected: Bool = false
    
    // 00 bet
    @State private var is00BetSelected: Bool = false
    
    // Column bets
    @State private var is1stColBetSelected: Bool = false
    @State private var is2ndColBetSelected: Bool = false
    @State private var is3rdColBetSelected: Bool = false
    
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
                        // Wheel
                        RouletteWheelView(wheel: wheel, rotation: $rotation)
                            .frame(width: 250, height: 250)
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
                        spinWheel()
                    }
                    // Button to pull up the bet table
                    Button("BET") {
                        withAnimation {
                            showingBetSheet = true
                        }
                    }
                    .padding()
                }
                if showingBetSheet {
                    // Dim the background
                    SwiftUI.Color(.black).opacity(0.4)
                        .ignoresSafeArea()
                        .transition(.opacity)
                    
                    // Bet sheet
                    BetSheetView(coins: $coins,
                                 selectedNumberBets: $selectedNumberBets,
                                 isEvenBetSelected: $isEvenBetSelected,
                                 isOddBetSelected: $isOddBetSelected,
                                 isRedBetSelected: $isRedBetSelected,
                                 isBlackBetSelected: $isBlackBetSelected,
                                 is1to18BetSelected: $is1to18BetSelected,
                                 is19to36BetSelected: $is19to36BetSelected,
                                 is1st12BetSelected: $is1st12BetSelected,
                                 is2nd12BetSelected: $is2nd12BetSelected,
                                 is3rd12BetSelected: $is3rd12BetSelected,
                                 is0BetSelected: $is0BetSelected,
                                 is00BetSelected: $is00BetSelected,
                                 is1stColBetSelected: $is1stColBetSelected,
                                 is2ndColBetSelected: $is2ndColBetSelected,
                                 is3rdColBetSelected: $is3rdColBetSelected,
                                 showingBetSheet: $showingBetSheet)
                        .transition(.move(edge: .bottom))
                }
            }
            Spacer()
            // Leave button
            Button("Leave") {
                path.append(.finish)
            }
        }
    }
    
    // Helper function to spin the roulette wheel
    func spinWheel() {
        let result = wheel.spinWithIndex()
        winningPocket = result.pocket

        let sliceAngle = 360.0 / Double(wheel.pockets.count)
        let winningAngle = sliceAngle * Double(result.index)

        rotation += 360 * 5 + (360 - winningAngle)
        
        // Payout
        if let winningNumber = Int(result.pocket.displayNumber) {
            // Number Bet
            if selectedNumberBets.contains(winningNumber) {
                coins += betAmount * 36
            }
            // 0 Bet
            if is0BetSelected && winningNumber == 0 {
                coins += betAmount * 36
            }
            // 00 Bet
            if is00BetSelected && winningNumber == 00 {
                coins += betAmount * 36
            }
            // EVEN Bet (don't payout for 0)
            if isEvenBetSelected && winningNumber % 2 == 0 && winningNumber != 0 {
                coins += betAmount * 2
            }
            // ODD Bet (don't payout for 00)
            if isOddBetSelected && winningNumber % 2 == 1 && winningNumber != -1 {
                coins += betAmount * 2
            }
            // RED Bet
            if isRedBetSelected && redNumbers.contains(winningNumber) {
                coins += betAmount * 2
            }
            // BLACK Bet
            if isBlackBetSelected && !redNumbers.contains(winningNumber) {
                coins += betAmount * 2
            }
            // 1 to 18 Bet
            if is1to18BetSelected && winningNumber >= 1 && winningNumber <= 18 {
                coins += betAmount * 2
            }
            // 19 to 36 Bet
            if is19to36BetSelected && winningNumber >= 19 && winningNumber <= 36 {
                coins += betAmount * 2
            }
            // 1st 12 Bet
            if is1st12BetSelected && winningNumber >= 1 && winningNumber <= 12 {
                coins += betAmount * 3
            }
            // 2nd 12 Bet
            if is2nd12BetSelected && winningNumber >= 13 && winningNumber <= 24 {
                coins += betAmount * 3
            }
            // 3rd 12 Bet
            if is3rd12BetSelected && winningNumber >= 25 && winningNumber <= 36 {
                coins += betAmount * 3
            }
            // 1st Column Bet
            if is1stColBetSelected && winningNumber % 3 == 1 {
                coins += betAmount * 3
            }
            // 2nd Column Bet (don't payout for 00)
            if is2ndColBetSelected && winningNumber % 3 == 2 && winningNumber != -1 {
                coins += betAmount * 3
            }
            // 3rd Column Bet (don't payout for 0)
            if is3rdColBetSelected && winningNumber % 3 == 0 && winningNumber != 0 {
                coins += betAmount * 3
            }
        }
        
        // Clear the bets after the wheel is spun
        selectedNumberBets.removeAll()
        isEvenBetSelected = false
        isOddBetSelected = false
        isRedBetSelected = false
        isBlackBetSelected = false
        is1to18BetSelected = false
        is19to36BetSelected = false
        is1st12BetSelected = false
        is2nd12BetSelected = false
        is3rd12BetSelected = false
        is0BetSelected = false
        is00BetSelected = false
        is1stColBetSelected = false
        is2ndColBetSelected = false
        is3rdColBetSelected = false
    }
}
