//
//  LetterTile.swift
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