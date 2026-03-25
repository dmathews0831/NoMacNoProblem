//
//  SettingsView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var path: [Route]
    
    var body: some View {
        VStack {
            Spacer()
            Text("Settings Screen")
            Spacer()
            Button("Back") {
                path.append(.mainMenu)
            }
        }
    }
}
