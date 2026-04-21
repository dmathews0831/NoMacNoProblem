//
//  TableOfBets.swift
//  project
//
//  Created by Alexander Joseph Toskey on 2/23/26.
//
//  This file contains the table of bets view for roulette

import SwiftUI

// Types of bets
enum BetType: Hashable {
    case number(Int)
    case zero
    case doubleZero
    case even
    case odd
    case red
    case black
    case low            // 1-18
    case high           // 19-36
    case dozen(Int)     // 1 for 1-12, 2 for 13-24, 3 for 25-36
    case column(Int)    // 1 for 1st col, 2 for 2nd col, 3 for 3rd col.
}

// Main table view
struct TableOfBets: View {
    
    @Binding var coins: Int
    @Binding var bets: [BetType: Int]
    
    // Bet amount set by the player
    let betAmount: Int
    
    // Roulette number coloring
    let redNumbers: Set<Int> = [
        1,3,5,7,9,
        12,14,16,18,
        19,21,23,25,27,
        30,32,34,36
    ]
    
    let rowHeight: CGFloat = 50
    let rowSpacing: CGFloat = 1
    
    var body: some View {
        HStack(spacing: -10) {
            
            // First column
            VStack() {
                toggleBetCell("1 to 18", isSelected: bets[.low] != nil, isOnSide: true) {
                    placeBet(.low)
                }
                
                toggleBetCell("EVEN", isSelected: bets[.even] != nil, isOnSide: true) {
                    placeBet(.even)
                }
                
                toggleBetCell("RED", isSelected: bets[.red] != nil, isOnSide: true) {
                    placeBet(.red)
                }
                
                toggleBetCell("BLACK", isSelected: bets[.black] != nil, isOnSide: true) {
                    placeBet(.black)
                }
                
                toggleBetCell("ODD", isSelected: bets[.odd] != nil, isOnSide: true) {
                    placeBet(.odd)
                }
                
                toggleBetCell("19 to 36", isSelected: bets[.high] != nil, isOnSide: true) {
                    placeBet(.high)
                }
            }
            
            // Second column
            VStack() {
                toggleBetCell("1st 12", isSelected: bets[.dozen(1)] != nil, isOnSide: true) {
                    placeBet(.dozen(1))
                }
                toggleBetCell("2nd 12", isSelected: bets[.dozen(2)] != nil, isOnSide: true) {
                    placeBet(.dozen(2))
                }
                toggleBetCell("3rd 12", isSelected: bets[.dozen(3)] != nil, isOnSide: true) {
                    placeBet(.dozen(3))
                }
            }
            
            // Main table
            VStack(spacing: -20) {
                
                // Top row
                HStack(spacing: -10) {
                    toggleBetCell("0", isSelected: bets[.zero] != nil, isOnSide: false) {
                        placeBet(.zero)
                    }
                    toggleBetCell("00", isSelected: bets[.doubleZero] != nil, isOnSide: false) {
                        placeBet(.doubleZero)
                    }
                }
                
                // Number grid
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: -10), count: 3),
                    spacing: -10
                ) {
                    ForEach(1...36, id: \.self) { number in
                        numberCell(number)
                    }
                }
                
                // Bottom row
                HStack(spacing: -10) {
                    toggleBetCell("2 to 1", isSelected: bets[.column(1)] != nil, isOnSide: false) {
                        placeBet(.column(1))
                    }
                    toggleBetCell("2 to 1", isSelected: bets[.column(2)] != nil, isOnSide: false) {
                        placeBet(.column(2))
                    }
                    toggleBetCell("2 to 1", isSelected: bets[.column(3)] != nil, isOnSide: false) {
                        placeBet(.column(3))
                    }
                }
            }
        }
        .padding()
    }
    
    // Helper to get the height for each row
    func heightForRows(_ rows: Int) -> CGFloat {
        CGFloat(rows) * rowHeight + CGFloat(rows - 1) * rowSpacing
    }
    
    // Place a bet when the player clicks on a cell on the table
    func placeBet(_ type: BetType) {
        if let existingAmount = bets[type] {
            // Remove bet and refund
            coins += existingAmount
            bets.removeValue(forKey: type)
        }
        else {
            // Place new bet
            guard coins >= betAmount else { return }
            bets[type] = betAmount
            coins -= betAmount
        }
    }
    
    // Bet square view generator for the number bets
    // FUNCTIONAL REQUIREMENT: The player should be able to place bets on the roulette table
    func numberCell(_ number: Int) -> some View {
        let type = BetType.number(number)
        let amount = bets[type] ?? 0

        return Button(action: {
            placeBet(type)
        }) {
            Text("\(number)\n\(amount > 0 ? "\(amount)" : "")")
                .font(.caption)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(amount > 0 ? SwiftUI.Color.yellow : numberColor(number))
                .foregroundColor(.white)
                .cornerRadius(6)
        }
        .frame(width:50, height:50)
    }
    
    // Bet square view generator for the other non-number bets
    // FUNCTIONAL REQUIREMENT: The player should be able to place bets on the roulette table
    func toggleBetCell(
        _ text: String,
        isSelected: Bool,
        isOnSide: Bool,
        color: SwiftUI.Color = .green,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(text)
                .font(.caption)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(isSelected ? SwiftUI.Color.yellow : color)
                .foregroundColor(.white)
                .cornerRadius(6)
                .rotationEffect(.degrees(isOnSide ? -90 : 0))
        }
        .frame(width:50, height:100)
    }
    
    // Basic red/black coloring
    func numberColor(_ number: Int) -> SwiftUI.Color {
        redNumbers.contains(number) ? .red : .black
    }
}

// Window view showing the table, betting slider, and appropriate buttons
struct BetSheetView: View {
    
    @Binding var coins: Int
    @Binding var bets: [BetType: Int]
    @Binding var currentBetAmount: Int
    @Binding var showingBetSheet: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                
                VStack {
                    Text("\(coins)")
                    Text("Bet Amount: \(currentBetAmount)")
                        .font(.caption)
                    if coins < 10 {
                        Text("Not enough coins to place a bet")
                            .foregroundColor(.red)
                    }
                    // Bet slider to adjust how much the player wants to bet
                    Slider(
                        value: Binding(
                            get: { Double(currentBetAmount) },
                            set: { newValue in
                                currentBetAmount = max(0, Int(newValue / 10) * 10)
                            }
                        ),
                        in: 0...Double(max(coins, 10)),
                        step: 10
                    )
                    .disabled(coins < 10)
                    .frame(height: 20)
                    
                }
                
                // Table of bets in a scroll view
                ScrollView {
                    TableOfBets(coins: $coins, bets: $bets, betAmount: currentBetAmount)
                }
                .background(.black)
                
                // Button to return to the wheel
                Button("WHEEL") {
                    withAnimation {
                        showingBetSheet = false
                    }
                }
                .font(.caption)
                .frame(width:100, height:20)
                .background(SwiftUI.Color(.blue))
                .foregroundColor(.white)
                .cornerRadius(10)
                
            }
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity)
            .background(SwiftUI.Color(.black))
            .cornerRadius(20)
            .shadow(radius: 10)
        }
        .ignoresSafeArea()
    }
}

/**
struct BetSheetView: View {
    
    @Binding var coins: Int
    @Binding var bets: [BetType: Int]
    @Binding var currentBetAmount: Int
    @Binding var showingBetSheet: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                
                Text("Place Your Bets")
                    .font(.headline)
                    .padding()
                
                VStack {
                    Text("Bet Amount: \(currentBetAmount)")
                    if coins < 10 {
                        Text("Not enough coins to place a bet")
                            .foregroundColor(.red)
                    }
                    Slider(
                        value: Binding(
                            get: { Double(currentBetAmount) },
                            set: { newValue in
                                currentBetAmount = max(0, Int(newValue / 10) * 10)
                            }
                        ),
                        in: 0...Double(max(coins, 10)),
                        step: 10
                    )
                    .disabled(coins < 10)
                    
                }
                .padding()
                
                // Table of bets
                ScrollView {
                    TableOfBets(coins: $coins, bets: $bets, betAmount: currentBetAmount)
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
}
*/
