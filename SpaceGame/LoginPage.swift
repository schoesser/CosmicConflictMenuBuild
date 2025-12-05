//
//  LoginPage.swift
//  SpaceGame
//
//  Created by Alexander Schösser on 09.12.25.
//

import Foundation
import SwiftUI

// Assume MainMenuButtonStyle (or a similar style like ThickRoundedButtonStyle) is defined in a common helper file or accessible.
// For this example, I'll define a basic stub for ThickRoundedButtonStyle to allow compilation.
struct ThickRoundedButtonStyle: ButtonStyle {
    var background: Color
    var foreground: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 20, weight: .bold, design: .monospaced))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .foregroundColor(foreground)
            .background(RoundedRectangle(cornerRadius: 18).fill(background))
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .padding(.horizontal, 4)
    }
}


// MARK: - LoginPage with Animated Space Styling

struct LoginPage: View {

    // FIX 1: Add Binding to communicate login status to the parent App struct
    @Binding var isLoggedIn: Bool

    @State private var username: String = ""
    @State private var password: String = ""
    
    // Animation State and Colors
    @State private var hueRotation: Double = 0.0
    let primaryBackground = Color(red: 0.1, green: 0.0, blue: 0.3) // Deep Violet/Navy
    let accentOrange = Color.cyan // Electric Cyan

    // --- Internal Star Data Structures ---
    // NOTE: If these are identical to the ones in ContentView, consider moving them to a shared file.
    private struct Star: Identifiable {
        let id = UUID()
        let initialX: CGFloat
        let initialY: CGFloat
        let size: CGFloat
        let opacity: Double
        let driftVelocity: CGSize
    }
    
    private let stars: [Star] = {
        var starArray: [Star] = []
        let count = 200
        for _ in 0..<count {
            starArray.append(Star(
                initialX: CGFloat.random(in: 0...1),
                initialY: CGFloat.random(in: 0...1),
                size: CGFloat.random(in: 1...3),
                opacity: Double.random(in: 0.3...0.8),
                driftVelocity: CGSize(
                    width: CGFloat.random(in: -0.05...0.05),
                    height: CGFloat.random(in: -0.05...0.05)
                )
            ))
        }
        return starArray
    }()
    // --- End Internal Star Data Structures ---


    var body: some View {
        TimelineView(.animation) { timeline in
            GeometryReader { geometry in
                ZStack {
                    
                    // 1. Animated Starfield Background and Hue Shift
                    primaryBackground
                        .hueRotation(.degrees(hueRotation))
                        .ignoresSafeArea()
                        .onAppear {
                            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                                hueRotation = 20
                            }
                        }
                    
                    // Star Particles
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

                    // 2. Foreground Content
                    VStack(spacing: 20) {

                        // Title: Space font and color
                        Text("Login")
                            .font(.system(size: 32, weight: .heavy, design: .monospaced))
                            .foregroundColor(accentOrange)
                            .shadow(color: accentOrange.opacity(0.8), radius: 8)
                            .padding(.top, 50) // Adjust spacing from top

                        Spacer()
                        
                        // USERNAME FIELD
                        TextField("Username", text: $username)
                            .textFieldStyle(.plain)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(accentOrange.opacity(0.2)))
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(accentOrange.opacity(0.5), lineWidth: 1)
                            )
                            .tint(.white)

                        // PASSWORD FIELD
                        SecureField("Password", text: $password)
                            .textFieldStyle(.plain)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(accentOrange.opacity(0.2)))
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(accentOrange.opacity(0.5), lineWidth: 1)
                            )
                            .tint(.white)

                        // FIX 2: Use a standard Button to set isLoggedIn to true
                        Button("Login") {
                            // Implement your actual authentication logic here
                            // On success:
                            self.isLoggedIn = true
                        }
                        .buttonStyle(ThickRoundedButtonStyle(
                            background: accentOrange,
                            foreground: primaryBackground.opacity(0.9)
                        ))
                        .padding(.top, 10)

                        Spacer()
                    }
                    .padding(.horizontal, 28)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
}

#Preview {
    // Pass a constant binding for previewing
    struct LoginPreviewWrapper: View {
        @State private var loggedIn = false
        var body: some View {
            LoginPage(isLoggedIn: $loggedIn)
                .preferredColorScheme(.dark)
        }
    }
    return LoginPreviewWrapper()
}
