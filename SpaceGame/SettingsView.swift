//
//  SettingsView.swift
//  SpaceGame
//
//  Created by Alexander Schösser on 09.12.25.
//

import Foundation
import SwiftUI

// NOTE: All helper structs and functions (Star, stars, AnimatedSpaceBackground, MainMenuButtonStyle)
// are assumed to be defined once in ContentView.swift or a shared file.
// They are removed here to prevent "Invalid redeclaration" errors.

// MARK: - SETTINGSCONTENTVIEW

struct SettingsContentView: View {
    // New Binding to allow navigation back to ContentView
    @Binding var showSettings: Bool

    @State private var volume: Double = 0.75
    @State private var brightness: Double = 0.5
    @State private var vibrationFeedback: Bool = true
    @State private var language: String = "English"
    
    let languages = ["English", "Spanish", "French", "German"]
    let accentColor = Color.cyan
    let primaryBackground = Color(red: 0.1, green: 0.0, blue: 0.3)

    var body: some View {
        ZStack {
            // Using the shared AnimatedSpaceBackground function
            AnimatedSpaceBackground()
            
            VStack {
                // Title and Back Button
                HStack {
                    Text("GAME SETTINGS")
                        .font(.system(size: 32, weight: .heavy, design: .monospaced))
                        .foregroundColor(accentColor)
                        .shadow(color: accentColor.opacity(0.7), radius: 8)
                    
                    Spacer()
                    
                    Button("Close") {
                        showSettings = false // Action to return to Main Menu
                    }
                    // Using the shared MainMenuButtonStyle
                    .buttonStyle(MainMenuButtonStyle(background: .gray.opacity(0.5), foreground: .white, border: .gray))
                    .frame(width: 100) // Constrain size for the back button
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
                
                // Form content
                Form {
                    // Section 1: Audio & Visual
                    Section(header: Text("Audio & Visual")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(accentColor))
                    {
                        // Volume Slider
                        HStack {
                            Image(systemName: "speaker.wave.3.fill").foregroundColor(accentColor)
                            
                            Slider(value: $volume, in: 0...1, step: 0.05) { Text("Volume") }
                                .accentColor(accentColor)
                            
                            Text(String(format: "%.0f%%", volume * 100))
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .regular, design: .monospaced))
                        }
                        .padding(.vertical, 5)
                        .listRowBackground(primaryBackground.opacity(0.5))

                        // Brightness Slider
                        HStack {
                            Image(systemName: "sun.max.fill").foregroundColor(accentColor)
                            
                            Slider(value: $brightness, in: 0...1, step: 0.05) { Text("Brightness") }
                                .accentColor(accentColor)
                            
                            Text(String(format: "%.0f%%", brightness * 100))
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .regular, design: .monospaced))
                        }
                        .padding(.vertical, 5)
                        .listRowBackground(primaryBackground.opacity(0.5))
                    }
                    
                    // Section 2: Gameplay & Language
                    Section(header: Text("Gameplay")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(accentColor))
                    {
                        // Vibration Toggle
                        Toggle(isOn: $vibrationFeedback) {
                            Text("Vibration Feedback")
                                .foregroundColor(.white)
                        }
                        .tint(accentColor)
                        .listRowBackground(primaryBackground.opacity(0.5))
                        
                        // Language Picker
                        Picker("Language", selection: $language) {
                            ForEach(languages, id: \.self) { lang in
                                Text(lang).tag(lang)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .regular, design: .monospaced))
                            }
                        }
                        .pickerStyle(.menu)
                        .foregroundColor(.white)
                        .listRowBackground(primaryBackground.opacity(0.5))
                    }
                }
                .scrollContentBackground(.hidden)
                .foregroundColor(.white)
                .padding(.top, 10)
            }
        }
    }
}
