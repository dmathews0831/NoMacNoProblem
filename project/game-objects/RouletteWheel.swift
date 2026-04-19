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
    
    // Winning number
    var winningNumber: Int? = nil
    
    // API class used to fetch random number
    let apiService = APIService()
    
    init() {
        self.pockets = generatePockets();
    }
    
    // Fetch a random number from Random.org's API
    func loadData() async {
        do {
            winningNumber = try await apiService.fetchRandomNumber()
            print("Fetching random number from Random.org")
        } catch {
            print("Error fetching from Random.org: \(error)")
            winningNumber = pocketSequence.randomElement()
        }
    }
        
    // Spin function using API result
    func spin() -> RoulettePocket {
        // Default to randomElement() if API fetch failed
        let number = winningNumber ?? pocketSequence.randomElement()!
        return pockets.first(where: { $0.number == number })!
    }
        
    // Spin with index function using API result
    func spinWithIndex() -> (pocket: RoulettePocket, index: Int) {
        // Default to randomElement() if API fetch failed
        let number = winningNumber ?? pocketSequence.randomElement()!
            
        if let index = pockets.firstIndex(where: { $0.number == number }) {
            return (pockets[index], index)
        }
            
        return (pockets[0], 0) // fallback safety
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
                    // Rotate so top points toward center
                    .rotationEffect(midAngle / 64)
                    // Push outward
                    .offset(y: -radius * 0.95)
                    // Rotate into slice position
                    .rotationEffect(midAngle + Angle(degrees: 90.0))
            }
        }
    }
}
