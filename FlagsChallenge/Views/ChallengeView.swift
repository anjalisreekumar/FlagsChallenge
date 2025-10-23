//
//  ChallengeView.swift
//  FlagsChallenge
//
//  Created by Hariom Sharma on 22/10/25.
//

import SwiftUI

struct ChallengeView: View {
    @EnvironmentObject var viewModel: FlagChallengeViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("\(viewModel.timeRemaining)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Circle().fill(Color.blue))
                
                Text("Guess the country from the flag")
                    .font(.headline)
            }
            
            if let question = viewModel.currentQuestion {
                HStack(alignment: .top, spacing: 16) {
                    CountryView(countryCode: question.countryCode)
                        .frame(width: 100, height: 70)
                    
                    OptionGrid(question: question, viewModel: viewModel)
                }
            } else {
                Text("Loading...")
            }
        }
        .padding()
    }
}


//#Preview {
//    ChallengeView()
//}


struct OptionGrid: View {
    let question: Question
    @ObservedObject var viewModel: FlagChallengeViewModel
    
    private let gridItems = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: gridItems, spacing: 16) {
            ForEach(Array(question.countries.enumerated()), id: \.offset) { index, country in
                Button {
                    viewModel.selectAnswer(for: question, selectedIndex: index)
                } label: {
                    Text(country.countryName)
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .background(buttonBackground(for: country.id))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(viewModel.isInterval) // disable during interval phase
            }
        }
        .padding()
    }
    
    private func buttonBackground(for id: Int) -> Color {
        guard let selectedId = viewModel.selectedAnswerId else {
            return Color.blue.opacity(0.7)
        }
        if id == selectedId {
            return id == question.answerId ? Color.green : Color.red
        }
        return Color.blue.opacity(0.7)
    }
}



struct CountryView: View {
    let countryCode: String
    var body: some View {
        Image(countryCode)
            .resizable()
            .frame(width: 80, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 4))
        
    }
}
