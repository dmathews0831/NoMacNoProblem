//
//  MainMenuView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/22/26.
//

/**
import SwiftUI

struct mainMenuView: View {
    
    @Binding var path: [Route]
    @Binding var coins: Int
    
    var body: some View {
        VStack {
            balanceView
            claimBonusView
            
            Spacer()
            
            Button("PLAY") {
                currentScreen = .playSelect
            }
            .font(.largeTitle)
            .frame(width: 200, height: 100)
            .background(SwiftUI.Color(.blue))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            
            Spacer()
            
            HStack {
                Button {
                    currentScreen = .settings
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.title)
                }
                
                Spacer()
                
                Button {
                    currentScreen = .profile
                } label: {
                    Image(systemName: "person.circle.fill")
                        .font(.title)
                }
            }
            .padding()
        }
    }
}

*/
