//
//  ContentView.swift
//  WordleWeek
//
//  Created by Sumukh Paspuleti on 8/19/25.
//

import SwiftUI

struct LetterTile: View {
    let letter: String
    let backgroundColor: Color
    
    var body: some View {
        Text(letter.isEmpty ? " " : letter)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.black)
            .frame(width: 60, height: 60)
            .background(letter.isEmpty ? Color.gray.opacity(0.3) : backgroundColor)
            .border(Color.gray, width: 2)
            .cornerRadius(5)
    }
}

struct ContentView: View {
    @State var gridLetters: [[String]] = [
        ["W", "O", "R", "L", "D"],
        ["", "", "", "", ""],
        ["", "", "", "", ""],
        ["", "", "", "", ""],
        ["", "", "", "", ""],
        ["", "", "", "", ""]
    ]
    
    @State var gridColors: [[Color]] = [
        [.green, .yellow, .gray, .green, .gray],
        [.clear, .clear, .clear, .clear, .clear],
        [.clear, .clear, .clear, .clear, .clear],
        [.clear, .clear, .clear, .clear, .clear],
        [.clear, .clear, .clear, .clear, .clear],
        [.clear, .clear, .clear, .clear, .clear],
    ]
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<6, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(0..<5, id: \.self)  { col in
                        LetterTile(
                            letter: gridLetters[row][col],
                            backgroundColor: gridColors[row][col]
                        )
                    }
                }
            }
        }
        .padding()
    }
}
