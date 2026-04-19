//
//  SettingsView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var path: [Route]
    
    @AppStorage("darkModeEnabled") var darkModeEnabled: Bool = false
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("volumeLevel") var volumeLevel: Double = 50.0
    
    var body: some View {
        VStack {
            Text("Settings")
                .padding()
            Spacer()
            Toggle("Dark Mode", isOn: $darkModeEnabled)
            Toggle("Sound", isOn: $soundEnabled)
            Text("Adjust Volume")
            Slider(value: $volumeLevel, in: 0...100)
                .disabled(!soundEnabled)
                .opacity(soundEnabled ? 1.0 : 0.5)
            Spacer()
            Button("Back") {
                path.removeLast()
            }
        }
    }
}
