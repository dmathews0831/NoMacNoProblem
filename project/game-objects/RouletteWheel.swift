//
//  RouletteWheel.swift
//  project
//
//  Created by Alexander Joseph Toskey on 2/23/26.
//

import Foundation


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
            
        // Zero(s)
        pockets.append(RoulettePocket(number: 0, displayNumber: "0", color: .green))
        pockets.append(RoulettePocket(number: -1, displayNumber: "00", color: .green))
            
        // 1–36
        for number in pocketSequence {
            var color: RouletteColor = (number == 0 || number == -1) ? .green :
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
