//
//  TableOfBets.swift
//  project
//
//  Created by Alexander Joseph Toskey on 2/23/26.
//

import SwiftUI

struct TableOfBets: View {
    
    var body: some View {
        HStack(spacing: 8) {
            
            // FIRST COLUMN (6 bets)
            VStack(spacing: 8) {
                betCell("1 to 18")
                betCell("EVEN")
                betCell("RED", color: .red)
                betCell("BLACK", color: .black)
                betCell("ODD")
                betCell("19 to 36")
            }
            
            // SECOND COLUMN (3 bets)
            VStack(spacing: 8) {
                betCell("1st 12")
                betCell("2nd 12")
                betCell("3rd 12")
            }
            
            // MAIN TABLE (Columns 3–5)
            VStack(spacing: 8) {
                
                // TOP ROW (0 and 00 spanning width)
                HStack(spacing: 8) {
                    betCell("0", color: .green)
                    betCell("00", color: .green)
                }
                
                // NUMBER GRID
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3),
                    spacing: 8
                ) {
                    ForEach(1...36, id: \.self) { number in
                        betCell("\(number)",
                                color: number % 2 == 0 ? .black : .red)
                    }
                }
                
                // BOTTOM ROW (2 to 1 bets)
                HStack(spacing: 8) {
                    betCell("2 to 1")
                    betCell("2 to 1")
                    betCell("2 to 1")
                }
            }
        }
        .padding()
    }
}

// Bet cell
extension TableOfBets {
    
    func betCell(_ text: String, color: SwiftUI.Color = SwiftUI.Color(.green)) -> some View {
        Button(action: {
            print("Tapped \(text)")
        }) {
            Text(text)
                .font(.caption)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(6)
        }
    }
}
