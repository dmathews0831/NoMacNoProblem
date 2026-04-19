//
//  BalanceView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//

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
