//
//  ProfileView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//

import SwiftUI

struct ProfileView: View {
    
    @Binding var path: [Route]
    
    var body: some View {
        VStack {
            Spacer()
            Text("Profile Screen")
            Spacer()
            Button("Back") {
                path.append(.mainMenu)
            }
        }
    }
}
