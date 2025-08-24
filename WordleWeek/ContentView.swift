//
//  ContentView.swift
//  WordleWeek
//
//  Created by Sumukh Paspuleti on 8/19/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                // Title area with padding
                VStack {
                    Text("WordleWeek")
                        .font(.custom("SF Pro Display", size: 36))
                        .fontWeight(.bold)
                        .foregroundColor(.gray)

                    // Debugging Information
                    Text("Target: \(viewModel.targetWord)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    if !viewModel.currentGuess.isEmpty {
                        Text("Current: \(viewModel.currentGuess)")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    
                    if viewModel.isNewGame {
                        Text("New game started!")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
                
                Button("New Game") {
                    viewModel.startNewGame()
                }
                .font(.system(size: 18, weight: .semibold))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(height: 50)
                .frame(minWidth: 120)
                .padding(.horizontal, 20)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.2, green: 0.2, blue: 0.2),
                            Color(red: 0.2, green: 0.2, blue: 0.2)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(25)
                .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isPressed = false
                        viewModel.startNewGame()
                    }
                }
                
                // Game grid with optimized spacing
                VStack(spacing: 6) {
                    ForEach(0..<6, id: \.self) { row in
                        HStack(spacing: 6) {
                            ForEach(0..<5, id: \.self)  { col in
                                AnimatedLetterTile(
                                    letter: viewModel.gridLetters[row][col],
                                    backgroundColor: viewModel.gridColors[row][col],
                                    isAnimating: viewModel.animatingTiles.contains("\(row)-\(col)")
                                )
                            }
                            .scaleEffect(viewModel.gameWon && row == viewModel.currentRow - 1 ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: viewModel.gameWon)
                        }
                    }
                }
                
                Spacer(minLength: 5)
                
                
                GameStatusMessage(viewModel: viewModel)
                
                KeyboardView(viewModel: viewModel)
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.2, green: 0.2, blue: 0.2),
                    Color(red: 0.2, green: 0.2, blue: 0.2)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}
