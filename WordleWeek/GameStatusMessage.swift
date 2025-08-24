//
//  GameStatusMessage.swift
//  WordleWeek
//
//  Created by Sumukh Paspuleti on 8/23/25.
//

import SwiftUI

struct GameStatusMessage: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        Group {
            if viewModel.gameWon {
                VStack(spacing: 8) {
                    Text("🎉 Excellent! 🎉")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.42, green: 0.68, blue: 0.39))
                    
                    Text("You guessed the word!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .background(Color(red: 0.42, green: 0.68, blue: 0.39).opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(red: 0.42, green: 0.68, blue: 0.39), lineWidth: 1)
                )
            } else if viewModel.gameLost {
                VStack(spacing: 8) {
                    VStack {
                        Text("Game Over")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.47, green: 0.47, blue: 0.47))
                        
                        Text("The word was: \(viewModel.targetWord)")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
                    .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                    .cornerRadius(12)
                }
            }
            
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
            }
            
        }
        .padding()
    }
}
