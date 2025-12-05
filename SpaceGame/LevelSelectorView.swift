//
//  LevelSelectorView.swift
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

// --- Animated Background ---
func AnimatedSpaceBackgroundforLevelSelectorView() -> some View {
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

// --- Custom Button Style ---
struct MainMenuButtonStyleforLevelSelectorView: ButtonStyle {
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


// MARK: - LEVELSELECTORVIEW (Level Menu)

struct LevelSelectorView: View {
    @Binding var showGame: Bool
    @Binding var selectedLevel: GameLevel?
    @Binding var showLevelSelector: Bool
    
    let accentColor = Color.cyan

    var body: some View {
        ZStack {
            AnimatedSpaceBackground()

            VStack(spacing: 40) {
                Text("SELECT MISSION")
                    .font(.system(size: 44, weight: .heavy, design: .monospaced))
                    .bold()
                    .foregroundColor(accentColor)
                    .shadow(color: accentColor.opacity(0.8), radius: 12)
                    .padding(.top, 40)

                VStack(spacing: 16) {
                    // Level 1 Button: Launches game
                    Button(GameLevels.level1.name) {
                        selectedLevel = GameLevels.level1
                        showGame = true
                    }
                    .buttonStyle(MainMenuButtonStyle(background: accentColor))

                    // Level 2 Button: Launches game
                    Button(GameLevels.level2.name) {
                        selectedLevel = GameLevels.level2
                        showGame = true
                    }
                    .buttonStyle(MainMenuButtonStyle(background: .purple, foreground: .white, border: .yellow))
                    
                    // Button to return to the Main Menu
                    Button("Back to Main Menu") {
                        showLevelSelector = false
                    }
                    .buttonStyle(MainMenuButtonStyle(background: .gray.opacity(0.6), foreground: .white))
                    .padding(.top, 20)
                }
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white.opacity(0.15))
                        .stroke(accentColor, lineWidth: 2)
                        .shadow(color: accentColor.opacity(0.5), radius: 10)
                )
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
    }
}


