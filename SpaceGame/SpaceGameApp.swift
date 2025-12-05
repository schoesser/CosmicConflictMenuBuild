//
//  SpaceGameApp.swift
//  SpaceGame
//
//  Created by Alexander Wagner on 29.11.25.
//

import SwiftUI

// Assuming this is your main application file
@main
struct SpaceGameApp: App {
    
    // FIX 3: Use a State variable to control the main app flow
    @State private var isLoggedIn = false
    
    var body: some Scene {
        WindowGroup {
            // Use a transition animation for a smoother switch
            if isLoggedIn {
                // If logged in, show the main application content (ContentView)
                ContentView()
                    .transition(.opacity.animation(.easeOut(duration: 0.5)))
            } else {
                // If not logged in, show the LoginPage
                LoginPage(isLoggedIn: $isLoggedIn)
                    .transition(.opacity.animation(.easeIn(duration: 0.5)))
            }
        }
    }
}
