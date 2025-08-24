//
//  AnimatedLetterTile.swift
//  WordleWeek
//
//  Created by Sumukh Paspuleti on 8/19/25.
//

import SwiftUI

struct AnimatedLetterTile: View {
    let letter: String
    let backgroundColor: Color
    let isAnimating: Bool
    
    var body: some View {
        Text(letter.isEmpty ? " " : letter)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(textColor)
            .frame(width: 60, height: 60)
            .background(tileBackgroundColor)
            .border(Color.gray.opacity(0.5), width: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(borderColor, lineWidth: 2)
            )
            .cornerRadius(5)
            .scaleEffect(isAnimating ? 1.1 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: backgroundColor)
            .animation(.easeInOut(duration: 0.2), value: isAnimating)
    }
    
    private var tileBackgroundColor: Color {
        if letter.isEmpty {
            return Color(red: 0.95, green: 0.95, blue: 0.95)
        }
        switch backgroundColor {
        case .green:
            return Color(red: 0.42, green: 0.68, blue: 0.39) // Wordle green
        case .yellow:
            return Color(red: 0.79, green: 0.68, blue: 0.31) // Wordle yellow
        case .gray:
            return Color(red: 0.47, green: 0.47, blue: 0.47) // Wordle gray
        default:
            return Color(red: 0.95, green: 0.95, blue: 0.95)
        }
    }
        
    private var textColor: Color {
        letter.isEmpty ? Color.white : Color.black
    }
    
    private var borderColor: Color {
        letter.isEmpty ? Color(red: 0.83, green: 0.83, blue: 0.83) : Color.clear
    }
}
