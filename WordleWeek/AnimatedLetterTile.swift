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
            .foregroundColor(backgroundColor == .clear ? .black : .white)
            .frame(width: 60, height: 60)
            .background(letter.isEmpty ? Color.gray.opacity(0.2) : backgroundColor)
            .border(Color.gray.opacity(0.5), width: 2)
            .cornerRadius(5)
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: backgroundColor)
            .animation(.easeInOut(duration: 0.2), value: isAnimating)
    }
}
