//
//  KeyboardView.swift
//  WordleWeek
//
//  Created by Sumukh Paspuleti on 8/19/25.
//

import SwiftUI

struct KeyboardView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                ForEach(["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"], id: \.self) { letter in
                    Button(letter) {
                        viewModel.addLetter(letter)
                    }
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(viewModel.gameWon ? .gray : (viewModel.isCurrentGuessFull ? .gray : .white))
                    .frame(width: 35, height: 50)
                    .background(viewModel.gameWon ? Color.gray.opacity(0.1) : (viewModel.isCurrentGuessFull ? Color.gray.opacity(0.1) : Color.gray.opacity(0.3)))
                    .cornerRadius(8)
                }
            }
            
            HStack(spacing: 4) {
                ForEach(["A", "S", "D", "F", "G", "H", "J", "K", "L"], id: \.self) { letter in
                    Button(letter) {
                        viewModel.addLetter(letter)
                    }
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(viewModel.gameWon ? .gray : (viewModel.isCurrentGuessFull ? .gray : .white))
                    .frame(width: 35, height: 50)
                    .background(viewModel.gameWon ? Color.gray.opacity(0.1) : (viewModel.isCurrentGuessFull ? Color.gray.opacity(0.1) : Color.gray.opacity(0.3)))
                    .cornerRadius(8)
                }
            }
            
            HStack(spacing: 4) {
                ForEach(["Z", "X", "C", "V", "B", "N", "M"], id: \.self) { letter in
                    Button(letter) {
                        viewModel.addLetter(letter)
                    }
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(viewModel.gameWon ? .gray : (viewModel.isCurrentGuessFull ? .gray : .white))
                    .frame(width: 35, height: 50)
                    .background(viewModel.gameWon ? Color.gray.opacity(0.1) : (viewModel.isCurrentGuessFull ? Color.gray.opacity(0.1) : Color.gray.opacity(0.3)))
                    .cornerRadius(8)
                }
                
                Button("↵") {
                    if !viewModel.gameWon {
                        viewModel.submitGuess()
                    }
                }
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(viewModel.gameWon ? .gray : .white)
                .frame(width: 60, height: 50)
                .background(viewModel.gameWon ? Color.gray.opacity(0.1) : (viewModel.isCurrentGuessFull ? Color.orange : Color.orange.opacity(0.3)))
                .cornerRadius(8)
                .disabled(viewModel.gameWon || !viewModel.isCurrentGuessFull)

                
                Button("⌫") {
                    if !viewModel.gameWon {
                        viewModel.deleteLetter()
                    }
                }
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(viewModel.gameWon ? .gray : .white)
                .frame(width: 60, height: 50)
                .background(viewModel.gameWon ? Color.gray.opacity(0.1) : Color.red.opacity(0.7))
                .cornerRadius(8)
                .disabled(viewModel.gameWon)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 40)
    }
}
