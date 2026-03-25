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
    @Binding var showingBetSheet: Bool
    @Binding var selectedNumberBets: Set<Int>
    
    @Binding var wheel: RouletteWheel
    @Binding var rotation: Double
    @Binding var winningPocket: RoulettePocket?
    
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
                    
                    Button("BET") {
                        withAnimation {
                            showingBetSheet = true
                        }
                    }
                    .padding()
                }
                
                // Overlay (only shows when betting)
                if showingBetSheet {
                    SwiftUI.Color(.black).opacity(0.4)
                        .ignoresSafeArea()
                        .transition(.opacity)
                }
                
                if showingBetSheet {
                    BetSheetView(coins: $coins, selectedNumberBets: $selectedNumberBets, showingBetSheet: $showingBetSheet)
                        .transition(.move(edge: .bottom))
                }
            }
            
            
            Spacer()
            Button("Leave") {
                path.append(.finish)
            }
        }
    }
    
    // Helper function to spin the roulette wheel (potentially move to RouletteWheel.swift (?))
    func spinWheel() {
        let result = wheel.spinWithIndex()
        winningPocket = result.pocket

        let sliceAngle = 360.0 / Double(wheel.pockets.count)
        let winningAngle = sliceAngle * Double(result.index)

        rotation += 360 * 5 + (360 - winningAngle)
        
        // Payout
        if let winningNumber = Int(result.pocket.displayNumber) {
            if selectedNumberBets.contains(winningNumber) {
                coins += betAmount * 2
            }
        }
        
        // Clear the bets after the wheel is spun
        selectedNumberBets.removeAll()
    }
}
