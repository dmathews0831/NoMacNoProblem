//
//  TableOfBets.swift
//  project
//
//  Created by Alexander Joseph Toskey on 2/23/26.
//

import SwiftUI

struct TableOfBets: View {
    
    @Binding var selectedBets: Set<Int>
    @Binding var coins: Int
    let betAmount: Int
    
    var body: some View {
        HStack(spacing: 8) {
            
            // First column (non-interactive for now)
            VStack(spacing: 8) {
                staticCell("1 to 18")
                staticCell("EVEN")
                staticCell("RED", color: .red)
                staticCell("BLACK", color: .black)
                staticCell("ODD")
                staticCell("19 to 36")
            }
            
            // Second column
            VStack(spacing: 8) {
                staticCell("1st 12")
                staticCell("2nd 12")
                staticCell("3rd 12")
            }
            
            // Main table
            VStack(spacing: 8) {
                
                // Top row
                HStack(spacing: 8) {
                    staticCell("0", color: .green)
                    staticCell("00", color: .green)
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
                    staticCell("2 to 1")
                    staticCell("2 to 1")
                    staticCell("2 to 1")
                }
            }
        }
        .padding()
    }
}

// Bet cell
extension TableOfBets {
    
    // NUMBER CELL (interactive)
    func numberCell(_ number: Int) -> some View {
        let isSelected = selectedBets.contains(number)
        
        return Button(action: {
            if isSelected {
                // Optional: allow deselect + refund
                selectedBets.remove(number)
                coins += betAmount
            } else if coins >= betAmount {
                selectedBets.insert(number)
                coins -= betAmount
            }
        }) {
            Text("\(number)")
                .font(.caption)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(isSelected ? SwiftUI.Color(.yellow) : numberColor(number))
                .foregroundColor(.white)
                .cornerRadius(6)
        }
    }
    
    // Static cells (non-betting for now)
    func staticCell(_ text: String, color: SwiftUI.Color = SwiftUI.Color(.green)) -> some View {
        Text(text)
            .font(.caption)
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(6)
    }
    
    // Basic red/black coloring
    func numberColor(_ number: Int) -> SwiftUI.Color {
        number % 2 == 0 ? .black : .red
    }
}

struct BetSheetView: View {
    
    @Binding var coins: Int
    @Binding var selectedNumberBets: Set<Int>
    @Binding var showingBetSheet: Bool
    
    var body: some View {
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
}
