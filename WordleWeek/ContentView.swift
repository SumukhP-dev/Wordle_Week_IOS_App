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
    
    @State var isNewGame = false
    @State var errorMessage = ""
    
    init() {
        let randomWord = wordList.randomElement() ?? "WORLD"
        _targetWord = State(initialValue: randomWord)
        _gridLetters = State(initialValue: Array(repeating: Array(repeating: "", count: 5), count: 6))
        _gridColors = State(initialValue: Array(repeating: Array(repeating: .clear, count: 5), count: 6))
        _currentRow = State(initialValue: 0)
        _currentGuess = State(initialValue: "")
    }
    
    func startNewGame() {
        gridLetters = Array(repeating: Array(repeating: "", count: 5), count: 6)
        gridColors = Array(repeating: Array(repeating: .clear, count: 5), count: 6)
        currentRow = 0
        currentGuess = ""
    }
    
    func addLetter(_ letter: String) {
        // Only accept single alphabetic characters
        guard letter.count == 1,
              letter.rangeOfCharacter(from: CharacterSet.letters) != nil,
              currentGuess.count < 5 else {
            return
        }
        
        // Clear any error message when user starts typing
        errorMessage = ""
        
        let uppercaseLetter = letter.uppercased()
        currentGuess += uppercaseLetter
        gridLetters[currentRow][currentGuess.count - 1] = uppercaseLetter
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
    
    func selectNewTargetWord() {
        var newWord: String
        repeat {
            newWord = wordList.randomElement() ?? "WORLD"
        } while newWord == targetWord && wordList.count > 1
        
        targetWord = newWord
        isNewGame = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isNewGame = false
        }
    }
    
    func canSubmitGuess() -> Bool {
        // Check if current guess is exactly 5 letters
        return currentGuess.count == 5
    }
    
    func isValidWord(_ word: String) -> Bool {
        // Check if the word exists in our word list
        return wordList.contains(word.uppercased())
    }
    
    func submitGuess() {
        // Clear any previous error message
        errorMessage = ""
        
        // First check if guess is complete
        guard canSubmitGuess() else {
            errorMessage = "Word must be exactly 5 letters"
            return
        }
        
        // Check if it's a valid word
        guard isValidWord(currentGuess) else {
            errorMessage = "\(currentGuess) is not a valid word"
            return
        }
        
        print("Valid guess submitted: \(currentGuess)")
        
        // Move to the next row for next guess
        currentRow += 1
        currentGuess = ""
        
        // Check if we've used all 6 guesses
        if currentRow >= 6 {
            errorMessage = "Game over - no more guesses available"
        }
    }
        
    var body: some View {
        VStack(spacing: 8) {
            Text("Target: \(targetWord)")
                .font(.caption)
                .foregroundColor(isNewGame ? .green : .gray)
                .fontWeight(isNewGame ? .bold : .regular)
                .padding(.bottom, 5)
            
            Button("New Game") {
                selectNewTargetWord()
                startNewGame()
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
                            letter: gridLetters[row][col],
                            backgroundColor: gridColors[row][col]
                        )
                    }
                }
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
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
                        submitGuess()
                    }
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(width: 60, height: 50)
                    .background(Color.orange.opacity(0.7))
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
