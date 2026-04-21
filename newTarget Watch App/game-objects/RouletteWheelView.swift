//
//  RouletteWheelView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/18/26.
//
//  This file contains the view for the roulette wheel.

import SwiftUI

struct RouletteWheelView: View {
    
    // Rotation angle of the wheel
    @Binding var rotation: Double
    
    let wheel: RouletteWheel
    let numSlices: Int = 38

    var body: some View {
        ZStack {
            // Generate the 38 pockets
            ForEach(0..<wheel.pockets.count, id: \.self) { index in
                let sliceAngle: Double = 360.0 / Double(numSlices)
                let start = Angle(degrees: sliceAngle * Double(index))
                let end   = Angle(degrees: sliceAngle * Double(index + 1))

                WheelSlice(
                    startAngle: start,
                    endAngle: end,
                    color: getColor(for: wheel.pockets[index].color),
                    label: wheel.pockets[index].displayNumber
                )
            }
        }
        .rotationEffect(.degrees(rotation))
        .animation(.easeOut(duration: 4), value: rotation)
    }
    
    // Helper to get the color of the pocket
    func getColor(for rouletteColor: RouletteColor) -> SwiftUI.Color {
        switch rouletteColor {
        case .red: return .red
        case .black: return .black
        case .green: return .green
        }
    }
}
