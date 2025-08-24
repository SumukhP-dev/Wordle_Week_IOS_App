//
//  GameViewModel.swift
//  WordleWeek
//
//  Created by Sumukh Paspuleti on 8/19/25.
//

import SwiftUI
import Combine

var isCurrentGuessFull = false
var currentRow = 0

class GameViewModel: ObservableObject {
    @Published var gridLetters: [[String]] = Array(repeating: Array(repeating: "", count: 5), count: 6)
    @Published var gridColors: [[Color]] = Array(repeating: Array(repeating: .clear, count: 5), count: 6)
    @Published var currentGuess = ""
    @Published var targetWord = "WORLD"
    @Published var errorMessage = ""
    @Published var isNewGame = false
    
    
    let wordList = [
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
    
    init() {
        selectRandomWord()
    }
    
    func startNewGame() {
        gridLetters = Array(repeating: Array(repeating: "", count: 5), count: 6)
        gridColors = Array(repeating: Array(repeating: .clear, count: 5), count: 6)
        currentRow = 0
        currentGuess = ""
        selectRandomWord()
        errorMessage = ""
        isNewGame = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isNewGame = false
        }
    }
    
    func addLetter(_ letter: String) {
        guard !gameWon && !gameLost && currentRow < 6 else { return }
        
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
        
        isCurrentGuessFull = canSubmitGuess()
    }
    
    func deleteLetter() {
        if currentGuess.count > 0 {
            gridLetters[currentRow][currentGuess.count - 1] = ""
            currentGuess.removeLast()
        }
        
        isCurrentGuessFull = canSubmitGuess()
    }
    
    func selectRandomWord() {
        targetWord = wordList.randomElement() ?? "WORLD"
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
        guard canSubmitGuess() && !gameWon && !gameLost else {
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
        
        // Validate word exists in word list
        guard wordList.contains(currentGuess.uppercased()) else {
            print("\(currentGuess) is not a valid word")
            errorMessage = "Not in word list"
            return
        }
        
        // Check if guess is correct
        if currentGuess.uppercased() == targetWord.uppercased() {
            gameWon = true
            print("Congratulations! You guessed the word!")
            // TODO: Handle win condition
        } else if currentRow >= 5 {
            gameLost = true
            print("Game over! The word was: \(targetWord)")
            // TODO: Handle loss condition
        }
        
        if !gameWon {
            // Move to next row
            currentRow += 1
            currentGuess = ""
            print("Moving to row \(currentRow + 1)")
        }
    }
}
