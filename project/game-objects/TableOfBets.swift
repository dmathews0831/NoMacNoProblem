//
//  TableOfBets.swift
//  project
//
//  Created by Alexander Joseph Toskey on 2/23/26.
//

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
    case low   // 1 - 18
    case high  // 19 - 36
    case dozen(Int)
    case column(Int)
}

struct TableOfBets: View {
    
    @Binding var coins: Int
    @Binding var bets: [BetType: Int]
    
    let betAmount: Int
    
    // Real roulette coloring
    let redNumbers: Set<Int> = [
        1,3,5,7,9,
        12,14,16,18,
        19,21,23,25,27,
        30,32,34,36
    ]
    
    let rowHeight: CGFloat = 50
    let rowSpacing: CGFloat = 8
    
    var body: some View {
        HStack(spacing: 8) {
            
            // First column
            VStack(spacing: rowSpacing) {
                toggleBetCell("1 to 18", isSelected: bets[.low] != nil) {
                    placeBet(.low)
                }
                
                toggleBetCell("EVEN", isSelected: bets[.even] != nil) {
                    placeBet(.even)
                }
                
                toggleBetCell("RED", isSelected: bets[.red] != nil) {
                    placeBet(.red)
                }
                
                toggleBetCell("BLACK", isSelected: bets[.black] != nil) {
                    placeBet(.black)
                }
                
                toggleBetCell("ODD", isSelected: bets[.odd] != nil) {
                    placeBet(.odd)
                }
                
                toggleBetCell("19 to 36", isSelected: bets[.high] != nil) {
                    placeBet(.high)
                }
            }
            
            // Second column
            VStack(spacing: rowSpacing) {
                toggleBetCell("1st 12", isSelected: bets[.dozen(1)] != nil) {
                    placeBet(.dozen(1))
                }
                toggleBetCell("2nd 12", isSelected: bets[.dozen(2)] != nil) {
                    placeBet(.dozen(2))
                }
                toggleBetCell("3rd 12", isSelected: bets[.dozen(3)] != nil) {
                    placeBet(.dozen(3))
                }
            }
            
            // Main table
            VStack(spacing: 8) {
                
                // Top row
                HStack(spacing: 8) {
                    toggleBetCell("0", isSelected: bets[.zero] != nil) {
                        placeBet(.zero)
                    }
                    toggleBetCell("00", isSelected: bets[.doubleZero] != nil) {
                        placeBet(.doubleZero)
                    }
                }
                
                // Number grid
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3),
                    spacing: 8
                ) {
                    ForEach(1...36, id: \.self) { number in
                        numberCell(number)
                    }
                }
                
                // Bottom row
                HStack(spacing: 8) {
                    toggleBetCell("2 to 1", isSelected: bets[.column(1)] != nil) {
                        placeBet(.column(1))
                    }
                    toggleBetCell("2 to 1", isSelected: bets[.column(2)] != nil) {
                        placeBet(.column(2))
                    }
                    toggleBetCell("2 to 1", isSelected: bets[.column(3)] != nil) {
                        placeBet(.column(3))
                    }
                }
            }
        }
        .padding()
    }
    
    func heightForRows(_ rows: Int) -> CGFloat {
        CGFloat(rows) * rowHeight + CGFloat(rows - 1) * rowSpacing
    }
    
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
    }
    
    // Toggle cells
    func toggleBetCell(
        _ text: String,
        isSelected: Bool,
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
        }
    }
    
    // Basic red/black coloring
    func numberColor(_ number: Int) -> SwiftUI.Color {
        redNumbers.contains(number) ? .red : .black
    }
}

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
