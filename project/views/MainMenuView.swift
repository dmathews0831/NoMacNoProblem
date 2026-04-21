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
        .tint(.yellow)
    }
    
    var body: some View {
        VStack {
            BalanceView(coins: $coins)
            claimBonusView
            
            Spacer()
            
            ZStack {
                PokerChipView(color: .red, size: 260)
                Text("Mobile Casino")
                    .padding(5)
                    .font(Font.largeTitle.bold())
                    .foregroundStyle(.black)
                    .background(.white)
                    .opacity(0.9)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
            }
            
            Spacer()
            
            Button("PLAY") {
                path.append(.playSelect)
            }
            .font(.largeTitle)
            .frame(width: 200, height: 100)
            .background(.yellow)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            
            Spacer()
            
            HStack {
                Button {
                    path.append(.settings)
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.title)
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                Button {
                    path.append(.profile)
                } label: {
                    Image(systemName: "person.circle.fill")
                        .font(.title)
                        .foregroundStyle(.white)
                }
            }
            .padding()
        }
    }
}
