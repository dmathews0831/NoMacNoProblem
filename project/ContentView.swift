//
//  ContentView.swift
//  project
//
//  Created by Dylan Mathews on 2/9/26.
//

import SwiftUI

struct ContentView: View {

    @State private var wheel = RouletteWheel()
    @State private var rotation: Double = 0
    @State private var winningPocket: RoulettePocket? = nil
    
    // Initialize stored variables
    @AppStorage("playerName") var playerName: String = ""
    @AppStorage("coins") var coins: Int = 0

    var body: some View {
        VStack {

            TextField("Enter name:", text: $playerName).textFieldStyle(.roundedBorder)
            Text("Coins: \(coins)")
            Button("Claim bonus") {
                
                coins += 1000
            }
            
            ZStack {
                // Wheel
                RouletteWheelView(wheel: wheel, rotation: $rotation)
                    .frame(width: 250, height: 250)
                
                Circle()
                    .stroke(SwiftUI.Color.black, lineWidth: 2)
                    .fill(SwiftUI.Color.yellow)
                    .frame(width: 175, height: 175)
                    .shadow(radius: 2)
                    
            }
            .onTapGesture {
                spinWheel()
            }
            

            // Result text
            if let pocket = winningPocket {
                Text("Result: \(pocket.displayNumber)")
                    .font(.headline)
            } else {
                Text("Tap to Spin")
                    .font(.headline)
            }
        }
    }

    func spinWheel() {
        let result = wheel.spinWithIndex()
        winningPocket = result.pocket

        let sliceAngle = 360.0 / Double(wheel.pockets.count)
        let winningAngle = sliceAngle * Double(result.index)

        // Spin multiple times + land on correct slice
        rotation += 360 * 5 + (360 - winningAngle)
    }
}

struct BlackjackView: View {
    
    @State private var dealer = BlackjackDealer(deck: Deck())

    
    var body: some View {
        Text(dealer.toString())
        
    }
}

#Preview {
    ContentView()
}
