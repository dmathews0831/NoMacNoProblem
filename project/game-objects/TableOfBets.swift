//
//  TableOfBets.swift
//  project
//
//  Created by Alexander Joseph Toskey on 2/23/26.
//

import SwiftUI

struct TableOfBets: View {
    
    @Binding var coins: Int
    
    // Number bet
    @Binding var selectedBets: Set<Int>
    
    // Even/odd bets
    @Binding var isEvenBetSelected: Bool
    @Binding var isOddBetSelected: Bool
    
    //Color bets
    @Binding var isRedBetSelected: Bool
    @Binding var isBlackBetSelected: Bool
    
    // Range bets
    @Binding var is1to18BetSelected: Bool
    @Binding var is19to36BetSelected: Bool
    @Binding var is1st12BetSelected: Bool
    @Binding var is2nd12BetSelected: Bool
    @Binding var is3rd12BetSelected: Bool
    
    // 0 bet
    @Binding var is0BetSelected: Bool
    
    // 00 bet
    @Binding var is00BetSelected: Bool
    
    // Column bets
    @Binding var is1stColBetSelected: Bool
    @Binding var is2ndColBetSelected: Bool
    @Binding var is3rdColBetSelected: Bool
    
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
                toggleBetCell("1 to 18", isSelected: is1to18BetSelected) {
                    if is1to18BetSelected {
                        is1to18BetSelected = false
                        coins += betAmount
                    } else if coins >= betAmount {
                        is1to18BetSelected = true
                        coins -= betAmount
                    }
                }
                
                toggleBetCell("EVEN", isSelected: isEvenBetSelected) {
                    if isEvenBetSelected {
                        isEvenBetSelected = false
                        coins += betAmount
                    } else if coins >= betAmount {
                        isEvenBetSelected = true
                        coins -= betAmount
                    }
                }
                
                toggleBetCell("RED", isSelected: isRedBetSelected, color: SwiftUI.Color(.red)) {
                    if isRedBetSelected {
                        isRedBetSelected = false
                        coins += betAmount
                    } else if coins >= betAmount {
                        isRedBetSelected = true
                        coins -= betAmount
                    }
                }
                
                toggleBetCell("BLACK", isSelected: isBlackBetSelected, color: SwiftUI.Color(.black)) {
                    if isBlackBetSelected {
                        isBlackBetSelected = false
                        coins += betAmount
                    } else if coins >= betAmount {
                        isBlackBetSelected = true
                        coins -= betAmount
                    }
                }
                
                toggleBetCell("ODD", isSelected: isOddBetSelected) {
                    if isOddBetSelected {
                        isOddBetSelected = false
                        coins += betAmount
                    } else if coins >= betAmount {
                        isOddBetSelected = true
                        coins -= betAmount
                    }
                }
                
                toggleBetCell("19 to 36", isSelected: is19to36BetSelected) {
                    if is19to36BetSelected {
                        is19to36BetSelected = false
                        coins += betAmount
                    } else if coins >= betAmount {
                        is19to36BetSelected = true
                        coins -= betAmount
                    }
                }
            }
            
            // Second column
            VStack(spacing: rowSpacing) {
                toggleBetCell("1st 12", isSelected: is1st12BetSelected) {
                    if is1st12BetSelected {
                        is1st12BetSelected = false
                        coins += betAmount
                    } else if coins >= betAmount {
                        is1st12BetSelected = true
                        coins -= betAmount
                    }
                }
                toggleBetCell("2nd 12", isSelected: is2nd12BetSelected) {
                    if is2nd12BetSelected {
                        is2nd12BetSelected = false
                        coins += betAmount
                    } else if coins >= betAmount {
                        is2nd12BetSelected = true
                        coins -= betAmount
                    }
                }
                toggleBetCell("3rd 12", isSelected: is3rd12BetSelected) {
                    if is3rd12BetSelected {
                        is3rd12BetSelected = false
                        coins += betAmount
                    } else if coins >= betAmount {
                        is3rd12BetSelected = true
                        coins -= betAmount
                    }
                }
            }
            
            // Main table
            VStack(spacing: 8) {
                
                // Top row
                HStack(spacing: 8) {
                    toggleBetCell("0", isSelected: is0BetSelected) {
                        if is0BetSelected {
                            is0BetSelected = false
                            coins += betAmount
                        } else if coins >= betAmount {
                            is0BetSelected = true
                            coins -= betAmount
                        }
                    }
                    toggleBetCell("00", isSelected: is00BetSelected) {
                        if is00BetSelected {
                            is00BetSelected = false
                            coins += betAmount
                        } else if coins >= betAmount {
                            is00BetSelected = true
                            coins -= betAmount
                        }
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
                    toggleBetCell("2 to 1", isSelected: is1stColBetSelected) {
                        if is1stColBetSelected {
                            is1stColBetSelected = false
                            coins += betAmount
                        } else if coins >= betAmount {
                            is1stColBetSelected = true
                            coins -= betAmount
                        }
                    }
                    toggleBetCell("2 to 1", isSelected: is2ndColBetSelected) {
                        if is2ndColBetSelected {
                            is2ndColBetSelected = false
                            coins += betAmount
                        } else if coins >= betAmount {
                            is2ndColBetSelected = true
                            coins -= betAmount
                        }
                    }
                    toggleBetCell("2 to 1", isSelected: is3rdColBetSelected) {
                        if is3rdColBetSelected {
                            is3rdColBetSelected = false
                            coins += betAmount
                        } else if coins >= betAmount {
                            is3rdColBetSelected = true
                            coins -= betAmount
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    func heightForRows(_ rows: Int) -> CGFloat {
        CGFloat(rows) * rowHeight + CGFloat(rows - 1) * rowSpacing
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
    @Binding var selectedNumberBets: Set<Int>
    
    // Even/odd bets
    @Binding var isEvenBetSelected: Bool
    @Binding var isOddBetSelected: Bool
    
    //Color bets
    @Binding var isRedBetSelected: Bool
    @Binding var isBlackBetSelected: Bool
    
    // Range bets
    @Binding var is1to18BetSelected: Bool
    @Binding var is19to36BetSelected: Bool
    @Binding var is1st12BetSelected: Bool
    @Binding var is2nd12BetSelected: Bool
    @Binding var is3rd12BetSelected: Bool
    
    // 0 Bet
    @Binding var is0BetSelected: Bool
    
    // 00 bet
    @Binding var is00BetSelected: Bool
    
    // Column bets
    @Binding var is1stColBetSelected: Bool
    @Binding var is2ndColBetSelected: Bool
    @Binding var is3rdColBetSelected: Bool
    
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
                        coins: $coins,
                        selectedBets: $selectedNumberBets,
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
