//
//  BalanceView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//
// TASK 2: View Balance - Display current coin balance
// Custom Views - Reusable component for balance display
// Data Binding - @Binding for reactive coin updates
// Responsiveness - Uses smaller font (subheadline) for watch display

import SwiftUI

struct BalanceView: View {
    // Data Binding - @Binding allows parent and child to sync coin value
    @Binding var coins: Int
    
    var body: some View {
        Text("Balance: \(coins)")
            .font(.subheadline)
            .padding(.top)
    }
}
