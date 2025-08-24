//
//  ContentView.swift
//  WordleWeek
//
//  Created by Sumukh Paspuleti on 8/19/25.
//

import SwiftUI

var gameWon = false
var gameLost = false

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        VStack(spacing: 8) {
            // Debugging Information
            VStack {
                Text("Target: \(viewModel.targetWord)")
                    .font(.caption)
                    .foregroundColor(.gray)
                if !viewModel.currentGuess.isEmpty {
                    Text("Current: \(viewModel.currentGuess)")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            .padding(.bottom, 10)
            
            Button("New Game") {
                viewModel.startNewGame()
            }
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(10)
            .padding(.bottom, 10)
            
            ForEach(0..<6, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(0..<5, id: \.self)  { col in
                        LetterTile(
                            letter: viewModel.gridLetters[row][col],
                            backgroundColor: viewModel.gridColors[row][col]
                        )
                    }
                    .scaleEffect(gameWon && row == currentRow - 1 ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: gameWon)
                }
            }
            
            if gameWon {
                Text("🎉 Congratulations! You guessed it! 🎉")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.vertical, 10)
            }
            
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
            }
            
            KeyboardView(viewModel: viewModel)
        }
        .padding()
    }
}
