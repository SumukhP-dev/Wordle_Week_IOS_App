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
            .foregroundColor(backgroundColor == .clear ? .black : .white)
            .frame(width: 60, height: 60)
            .background(letter.isEmpty ? Color.gray.opacity(0.2) : backgroundColor)
            .border(Color.gray.opacity(0.5), width: 2)
            .cornerRadius(5)
            .animation(.easeInOut(duration: 0.3), value: backgroundColor)
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
        "APPLE", "BEACH", "CHAIR", "DANCE", "EAGLE",
        "FLAME", "GRAPE", "HOUSE", "IMAGE", "JOKER",
        "KNIFE", "LIGHT", "MOUSE", "NIGHT", "OCEAN",
        "PAPER", "QUEEN", "RADIO", "SNAKE", "TABLE",
        "UNDER", "VOICE", "WATER", "YOUNG", "ZEBRA",
        // Test words with duplicate letters
        "SPEED", "SPELL", "SWEET", "PIZZA", "DADDY"
    ]
    // Colors for guess feedback
    let correctColor = Color.green
    let wrongPositionColor = Color.yellow
    let incorrectColor = Color.gray
    
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
    
    func compareGuess(_ guess: String) -> [Color] {
        let guessArray = Array(guess.uppercased())
        let targetArray = Array(targetWord.uppercased())
        var colors: [Color] = Array(repeating: .gray, count: 5)
        var targetLetterCounts: [Character: Int] = [:]
        
        // Count occurances of each letter in target word
        for letter in targetArray {
            targetLetterCounts[letter, default: 0] += 1
        }
        
        // First pass: Mark correct positions (green)
        for i in 0..<5 {
            if guessArray[i] == targetArray[i] {
                colors[i] = .green
                targetLetterCounts[guessArray[i]]! -= 1
            }
        }
        
        // Second pass: Mark wrong positions (yellow)
        for i in 0..<5 {
            if colors[i] != .green && targetLetterCounts[guessArray[i], default: 0] > 0 {
                colors[i] = .yellow
                targetLetterCounts[guessArray[i]]! -= 1
            }
        }
        
        return colors
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
        
        // Validate guess has exactly 5 letters
        guard canSubmitGuess() else {
            errorMessage = "Word must be exactly 5 letters"
            return
        }
        
        // Validate all characters are letters
        guard currentGuess.allSatisfy({ $0.isLetter }) else {
            print("Guess must contain only letters")
            return
        }
        
        print("Evaluating guess: \(currentGuess) against target: \(targetWord)")
        
        // Evaluate the guess and get colors
        let resultColors = evaluateGuess(currentGuess)
        
        // Apply colors to the current row
        for i in 0..<5 {
            gridColors[currentRow][i] = resultColors[i]
        }
        
        // Validate word exists in world list
        guard wordList.contains(currentGuess.uppercased()) else {
            print("\(currentGuess) is not a valid word")
            // TODO: Show user feedback for invalid word
            return
        }
        
        // Check if guess is correct
        if currentGuess == targetWord {
            print("Congratulations! You guessed the word!")
            // TODO: Handle win condition
        } else if currentRow >= 5 {
            print("Game over! The word was: \(targetWord)")
            // TODO: Handle loss condition
        } else {
            // Move to next row
            currentRow += 1
            currentGuess = ""
            print("Moving to row \(currentRow + 1)")
        }
    }
    
    func evaluateGuess(_ guess: String) -> [Color] {
        var colors: [Color] = []
        let guessArray = Array(guess)
        let targetArray = Array(targetWord)
        
        // First pass: mark exact matches (green)
        var targetLetterCounts: [Character: Int] = [:]
        var exactMatches: [Bool] = Array(repeating: false, count: 5)
        
        // Count letters in target word and mark exact matches
        for i in 0..<5 {
            let targetLetter = targetArray[i]
            targetLetterCounts[targetLetter, default: 0] += 1
            
            if guessArray[i] == targetLetter {
                exactMatches[i] = true
                targetLetterCounts[targetLetter]! -= 1
            }
        }
        
        // Second pass: determine colors
        for i in 0..<5 {
            if exactMatches[i] {
                colors.append(correctColor)
            } else {
                let guessLetter = guessArray[i]
                if let count = targetLetterCounts[guessLetter], count > 0 {
                    colors.append(wrongPositionColor)
                    targetLetterCounts[guessLetter]! -= 1
                } else {
                    colors.append(incorrectColor)
                }
            }
        }
        
        return colors
    }
        
    var body: some View {
        VStack(spacing: 8) {
            // Debugging Information
            VStack {
                Text("Target: \(targetWord)")
                    .font(.caption)
                    .foregroundColor(.gray)
                if !currentGuess.isEmpty {
                    Text("Current: \(currentGuess)")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            .padding(.bottom, 10)
            
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
