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
    
    @State var currentRow = 1
    @State var currentGuess = ""
    @State var targetWord = "APPLE"
    @State var wordList = [
        "APPLE", "BREAD", "CHAIR", "DREAM", "EARTH",
        "FLAME", "GRAPE", "HOUSE", "IMAGE", "JUICE",
        "KNIFE", "LIGHT", "MUSIC", "NORTH", "OCEAN",
        "PAPER", "QUIET", "RIVER", "STONE", "TABLE",
        "UNDER", "VALUE", "WATER", "YOUNG", "ZEBRA",
        "BEACH", "CLOUD", "DANCE", "EAGLE", "FRESH",
        "GIANT", "HEART", "INDEX", "JOLLY", "KIDDO",
        "LUCKY", "MAGIC", "NOVEL", "ORBIT", "PLANT",
        "QUACK", "RADIO", "SMILE", "TRUST", "UNITY",
        "VOICE", "WHEEL", "EXTRA", "YACHT", "ZESTY",
        "BADGE", "CRAFT", "DODGE", "ENJOY", "FOCUS",
        "GUIDE", "HAPPY", "IDEAL", "JUMBO", "KNOWN",
        "LEMON", "MARCH", "NERDY", "OWNER", "PRIME",
        "QUOTE", "RAPID", "SPARK", "THICK", "URBAN"
    ]
    
    func addLetter(_ letter: String) {
        if currentGuess.count < 5 {
            currentGuess += letter
            gridLetters[currentRow][currentGuess.count - 1] = letter
        }
    }
    
    func deleteLetter() {
        if currentGuess.count > 0 {
            gridLetters[currentRow][currentGuess.count - 1] = ""
            currentGuess.removeLast()
        }
    }
    
    func selectRandomWord() {
        if let randomWord = wordList.randomElement() {
            targetWord = randomWord
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Target: \(targetWord)")
                .font(.headline)
                .foregroundColor(.red)
                .padding(.bottom, 10)
            
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
            
            VStack(spacing: 8) {
                HStack(spacing: 4) {
                    ForEach(["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"], id: \.self) { letter in
                        Button(letter) {
                            addLetter(letter)
                        }
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .frame(width: 35, height: 50)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                        
                    }
                }
                
                HStack(spacing: 4) {
                    ForEach(["A", "S", "D", "F", "G", "H", "J", "K", "L"], id: \.self) { letter in
                        Button(letter) {
                            addLetter(letter)
                        }
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .frame(width: 35, height: 50)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                        
                    }
                }
                
                
                HStack(spacing: 4) {
                    Button("ENTER") {
                        // Handle enter key
                    }
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(width: 60, height: 50)
                    .background(Color.gray.opacity(0.7))
                    .cornerRadius(8)
                    
                    ForEach(["Z", "X", "C", "V", "B", "N", "M"], id: \.self) { letter in
                        Button(letter) {
                            addLetter(letter)
                        }
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .frame(width: 35, height: 50)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                    }
                    
                    Button("DEL") {
                        deleteLetter()
                    }
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(width: 60, height: 50)
                    .background(Color.red.opacity(0.7))
                    .cornerRadius(8)
                }
            }
            .padding(.top, 20)
        }
        .padding()
        .onAppear() {
            selectRandomWord()
        }
    }
}
