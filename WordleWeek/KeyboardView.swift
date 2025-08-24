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
                    .foregroundColor(gameWon ? .gray : (isCurrentGuessFull ? .gray : .black))
                    .frame(width: 35, height: 50)
                    .background(gameWon ? Color.gray.opacity(0.1) : (isCurrentGuessFull ? Color.gray.opacity(0.1) : Color.gray.opacity(0.3)))
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
                    .foregroundColor(gameWon ? .gray : (isCurrentGuessFull ? .gray : .black))
                    .frame(width: 35, height: 50)
                    .background(gameWon ? Color.gray.opacity(0.1) : (isCurrentGuessFull ? Color.gray.opacity(0.1) : Color.gray.opacity(0.3)))
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
                    .foregroundColor(gameWon ? .gray : (isCurrentGuessFull ? .gray : .black))
                    .frame(width: 35, height: 50)
                    .background(gameWon ? Color.gray.opacity(0.1) : (isCurrentGuessFull ? Color.gray.opacity(0.1) : Color.gray.opacity(0.3)))
                    .cornerRadius(8)
                }
                
                Button("ENTER") {
                    if !gameWon {
                        viewModel.submitGuess()
                    }
                }
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(gameWon ? .gray : .white)
                .frame(width: 60, height: 50)
                .background(gameWon ? Color.gray.opacity(0.1) : (isCurrentGuessFull ? Color.orange : Color.orange.opacity(0.3)))
                .cornerRadius(8)
                .disabled(gameWon || !isCurrentGuessFull)

                
                Button("DEL") {
                    if !gameWon {
                        viewModel.deleteLetter()
                    }
                }
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(gameWon ? .gray : .black)
                .frame(width: 60, height: 50)
                .background(gameWon ? Color.gray.opacity(0.1) : Color.red.opacity(0.7))
                .cornerRadius(8)
                .disabled(gameWon)
            }
        }
        .padding(.top, 20)
    }
}
