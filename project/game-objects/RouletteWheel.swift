//
//  RouletteWheel.swift
//  project
//
//  Created by Alexander Joseph Toskey on 2/23/26.
//

import Foundation
import SwiftUI

enum RouletteColor {
    case red
    case black
    case green
}

struct RoulettePocket {
    let number: Int             // 0, 1, 2... use -1 for 00
    let displayNumber: String   // "0", "00"...
    let color: RouletteColor
}

class RouletteWheel {
    
    // -1 represents 00 for now, want to use Int instead of String
    let pocketSequence: [Int] = [0, 28, 9, 26, 30, 11, 7, 20, 32, 17, 5, 22, 34, 15, 3, 24, 36, 13, 1,
                                 -1, 27, 10, 25, 29, 12, 8, 19, 31, 18, 6, 21, 33, 16, 4, 23, 35, 14, 2];
    // Or using type inference:
    private(set) var pockets: [RoulettePocket] = [];
    
    init() {
        self.pockets = generatePockets();
    }
    
    // Return a random pocket
    func spin() -> RoulettePocket {
        return pockets.randomElement()!
    }

    // Return a random pocket with its index, good for animation
    func spinWithIndex() -> (pocket: RoulettePocket, index: Int) {
        let index = pocketSequence.randomElement()!
        return (pockets[index], index)
    }
    
    func generatePockets() -> [RoulettePocket] {
            
        let redNumbers: Set<Int> = [
            1,3,5,7,9,12,14,16,18,
            19,21,23,25,27,30,32,34,36
        ];
            
        var pockets: [RoulettePocket] = [];
            
        // Zeros
        pockets.append(RoulettePocket(number: 0, displayNumber: "0", color: .green))
        pockets.append(RoulettePocket(number: -1, displayNumber: "00", color: .green))
            
        // 1–36
        for number in pocketSequence {
            let color: RouletteColor = (number == 0 || number == -1) ? .green :
                                        redNumbers.contains(number)  ? .red :
                                                                       .black
            if (number == -1) {
                pockets.append(RoulettePocket(number: number, displayNumber: "00", color: color))
            }
            else {
                pockets.append(RoulettePocket(number: number, displayNumber: String(number), color: color))
            }
        }
            
        return pockets
    }
    
    func angleForPocket(at index: Int) -> Double {
        let sliceAngle = 360.0 / Double(pockets.count)
        return sliceAngle * Double(index)
    }
}

struct WheelSlice: View {
    let startAngle: Angle
    let endAngle: Angle
    let color: SwiftUI.Color
    let label: String

    var body: some View {
        GeometryReader { geo in
            let rect = geo.frame(in: .local)
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius = min(rect.width, rect.height) / 2

            let midAngle = Angle(
                degrees: (startAngle.degrees + endAngle.degrees) / 2
            )

            ZStack {
                // Slice shape
                Path { path in
                    path.move(to: center)

                    path.addArc(
                        center: center,
                        radius: radius,
                        startAngle: startAngle,
                        endAngle: endAngle,
                        clockwise: false
                    )

                    path.closeSubpath()
                }
                .fill(color)

                // Number at outer edge of slice
                Text(label)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    // Rotate into slice position
                    .rotationEffect(midAngle)
                    // Push outward
                    .offset(y: -radius * 0.85)
                    // Rotate so top points toward center
                    .rotationEffect(startAngle)
            }
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.closeSubpath()

        return path
    }
}
