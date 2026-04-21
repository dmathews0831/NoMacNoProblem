//
//  SettingsView.swift
//  project
//
//  Created by Alexander Joseph Toskey on 3/25/26.
//
// TASK 4: App Settings Management - Sound and Volume
// Custom Views - SettingsView component
// Data Binding - @AppStorage for persistent settings across app sessions
// Responsiveness - Adapted for watch with compact layout

import SwiftUI

struct SettingsView: View {
    
    @Binding var path: [Route]
    
    // Data Binding - @AppStorage persists settings to device
    // Functional - Using Toggle and Slider for reactive controls
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
