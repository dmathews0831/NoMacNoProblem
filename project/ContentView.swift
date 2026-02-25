//
//  ContentView.swift
//  project
//
//  Created by Dylan Mathews on 2/9/26.
//

import SwiftUI

struct ContentView: View {
    
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
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
