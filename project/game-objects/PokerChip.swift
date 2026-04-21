//
//  PokerChip.swift
//  project
//
//  Created by Alexander Joseph Toskey on 2/23/26.
//
//  Description: This is a simple decorative poker chip which can spin

import SwiftUI

struct PokerChipView: View {
    
    var color: SwiftUI.Color = .red
    var size: CGFloat = 120
    
    // Rotation angle for animation
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            
            // Outer ring
            Circle()
                .fill(color)
            
            // White edge accents
            ForEach(0..<8) { i in
                Rectangle()
                    .fill(.white)
                    .frame(width: size * 0.15, height: size * 0.19)
                    .offset(y: -size * 0.4)
                    .rotationEffect(.degrees(Double(i) * 45))
                Circle()
                    .fill(.white)
                    .frame(width: size * 0.05, height: size * 0.05)
                    .offset(y: -size * 0.42)
                    .rotationEffect(.degrees(Double(i) * 45 + 22.5))

            }
            
            // Inner circle
            Circle()
                .fill(color)
                .frame(width: size * 0.55)
            Circle()
                .stroke(color, lineWidth: size * 0.05)
                .frame(width: size * 0.55)
            
            // Inner detail
            ForEach(0..<8) { i in
                Rectangle()
                    .fill(.white)
                    .frame(width: size * 0.1, height: size * 0.02)
                    .offset(y: -size * 0.24)
                    .rotationEffect(.degrees(Double(i) * 45 + 22.5))
            }
            
        }
        .frame(width: size, height: size)
        .shadow(radius: 5)
        .rotationEffect(.degrees(rotation)) // Rotating animation
            .onAppear {
                rotation = 360
            }
            .animation(
                .linear(duration: 10)
                    .repeatForever(autoreverses: false),
                value: rotation
            )
    }
}
                    
