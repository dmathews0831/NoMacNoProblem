//
//  MainMenuView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/22/26.
//

import SwiftUI

struct MainMenuView: View {
    
    @Binding var path: [Route]
    @Binding var coins: Int
    
    var claimBonusView: some View {
        Button("CLAIM DAILY BONUS") {
            coins += 1000
        }
        .buttonStyle(.borderedProminent)
    }
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            BalanceView(coins: $coins)
            claimBonusView
            
            Spacer()
            
            Button("PLAY") {
                path.append(.gameSelectSP)
            }
            .font(.title)
            .background(SwiftUI.Color(.blue))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 5, height: 5)))
            
            Spacer()
            
            HStack {
                Button {
                    path.append(.settings)
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.title)
                }
                
                Spacer()
                
                Button {
                    path.append(.profile)
                } label: {
                    Image(systemName: "person.circle.fill")
                        .font(.title)
                }
            }
            .padding()
        }
    }
}
