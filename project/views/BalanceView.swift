//
//  BalanceView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//
//  Description: This file contains the simple balance view struct to display the user's coin balance

import SwiftUI

struct BalanceView: View {
    @Binding var coins: Int
    
    var body: some View {
        Text("Balance: \(coins)")
            .font(.title2)
            .foregroundStyle(.white)
            .padding(.top)
    }
}
