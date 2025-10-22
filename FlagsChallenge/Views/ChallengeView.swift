//
//  ChallengeView.swift
//  FlagsChallenge
//
//  Created by Hariom Sharma on 22/10/25.
//

import SwiftUI

struct ChallengeView: View {
    var body: some View {
        VStack {
            HStack {
                Text("10")
                    .foregroundStyle(Color.white)
                    .background {
                        Circle()
                    }
                
                Text("Guess the country from the flag")
            }
            
            HStack {
                Image(systemName: "flag.fill")
                    .background(Color.red)
                    .frame(width: 100,height: 100)
                    .border(Color.pink)
                OptionGrid()
                
            }

        }
    }
}

#Preview {
    ChallengeView()
}


struct OptionGrid: View {
    let gridItems = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: gridItems, spacing: 16) {
            ForEach(1..<5, id: \.self) { index in
                Button {
                    // action
                } label: {
                    Text("Balah \(index)")
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .background(Color.blue.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
    }
}

