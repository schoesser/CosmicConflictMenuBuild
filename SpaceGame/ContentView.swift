//
//  ContentView.swift
//  SpaceGame
//
//  Created by Alexander Schösser on 09.12.25.
//
import SwiftUI

// MARK: - STUBS AND HELPERS (Required for compilation)

// --- Animation Data ---
fileprivate struct Star: Identifiable {
    let id = UUID()
    let initialX: CGFloat
    let initialY: CGFloat
    let size: CGFloat
    let opacity: Double
    let driftVelocity: CGSize
}

fileprivate let stars: [Star] = {
    var starArray: [Star] = []
    let count = 200
    for _ in 0..<count {
        starArray.append(Star(
            initialX: CGFloat.random(in: 0...1), initialY: CGFloat.random(in: 0...1),
            size: CGFloat.random(in: 1...3), opacity: Double.random(in: 0.3...0.8),
            driftVelocity: CGSize(width: CGFloat.random(in: -0.05...0.05), height: CGFloat.random(in: -0.05...0.05))
        ))
    }
    return starArray
}()

// --- Animated Background (Consolidated for use in all views) ---
func AnimatedSpaceBackground() -> some View {
    let primaryBackground = Color(red: 0.1, green: 0.0, blue: 0.3)
    return TimelineView(.animation) { timeline in
        GeometryReader { geometry in
            ZStack {
                primaryBackground.ignoresSafeArea()
                ForEach(stars) { star in
                    let time = timeline.date.timeIntervalSinceReferenceDate
                    let currentX = star.initialX + star.driftVelocity.width * CGFloat(time).truncatingRemainder(dividingBy: 100)
                    let currentY = star.initialY + star.driftVelocity.height * CGFloat(time).truncatingRemainder(dividingBy: 100)
                    let twinkleOpacity = (sin(time * 0.5 + star.initialX * 10) * 0.2 + 0.8) * star.opacity
                    Circle()
                        .fill(Color.white)
                        .frame(width: star.size, height: star.size)
                        .opacity(twinkleOpacity)
                        .position(
                            x: (currentX.truncatingRemainder(dividingBy: 1) + 1).truncatingRemainder(dividingBy: 1) * geometry.size.width,
                            y: (currentY.truncatingRemainder(dividingBy: 1) + 1).truncatingRemainder(dividingBy: 1) * geometry.size.height
                        )
                }
            }
        }
    }
}

// --- Custom Button Style (Consolidated for use in all views) ---
struct MainMenuButtonStyle: ButtonStyle {
    var background: Color = .cyan
    var foreground: Color = Color(red: 0.1, green: 0.0, blue: 0.3)
    var border: Color? = nil

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 20, weight: .bold, design: .monospaced))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .foregroundColor(foreground)
            .background(RoundedRectangle(cornerRadius: 18).fill(background))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(border ?? .clear, lineWidth: border == nil ? 0 : 3))
            .padding(.horizontal, 4)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .shadow(color: border ?? background, radius: 8)
    }
}

// MARK: - CONTENTVIEW (Main Router)

struct ContentView: View {
    @State private var showGame = false
    @State private var showLevelSelector = false
    @State private var selectedLevel: GameLevel? = nil
    
    // FIX: Add the state variable to control the visibility of SettingsContentView
    @State private var showSettings = false
    
    let accentColor = Color.cyan

    var body: some View {

        if showGame, let selectedLevel {
            // 1. Show GameView
            GameView(showGame: $showGame, level: selectedLevel)
            
        } else if showLevelSelector {
            // 2. Show LevelSelectorView (defined in the other file)
            LevelSelectorView(
                showGame: $showGame,
                selectedLevel: $selectedLevel,
                showLevelSelector: $showLevelSelector
            )
            
        } else if showSettings {
            // FIX: Show SettingsContentView when showSettings is true
            SettingsContentView(showSettings: $showSettings)
            
        } else {
            // 3. Show Main Menu
            ZStack {
                AnimatedSpaceBackground()

                VStack(spacing: 30) {
                    Text("SPACE GAME")
                        .font(.system(size: 44, weight: .heavy, design: .monospaced))
                        .bold()
                        .foregroundColor(accentColor)
                        .shadow(color: accentColor.opacity(0.8), radius: 12)
                        .padding(.bottom, 20)
                    
                    // Primary Levels Button
                    Button("Start Mission (Levels)") {
                        showLevelSelector = true
                    }
                    .buttonStyle(MainMenuButtonStyle(background: accentColor, border: .yellow))
                    .padding(.horizontal, 24)
                    
                    // Secondary Menu Buttons (Applied MainMenuButtonStyle)
                    VStack(spacing: 12) {
                        Button("Settings") {
                            // FIX: Set the state variable to show the settings view
                            showSettings = true
                        }
                        .buttonStyle(MainMenuButtonStyle(background: Color.white.opacity(0.15), foreground: .white, border: .gray))

                        Button("High Scores") {
                            // Action for High Scores
                        }
                        .buttonStyle(MainMenuButtonStyle(background: Color.white.opacity(0.15), foreground: .white, border: .gray))

                        // Exit Button with Red Glow
                        Button("Exit") {

                        }
                        .buttonStyle(MainMenuButtonStyle(background: .red, foreground: .white, border: .red.opacity(0.8)))
                        
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 24)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
