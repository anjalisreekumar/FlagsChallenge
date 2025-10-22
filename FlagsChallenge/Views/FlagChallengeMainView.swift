//
//  FlagChallengeMainView.swift
//  FlagsChallenge
//
//  Created by Hariom Sharma on 22/10/25.
//

import SwiftUI

struct FlagChallengeMainView: View {
    @StateObject var viewModel = FlagChallengeViewModel()
    var body: some View {
        VStack {
            TitleCard()
            Divider()
            switch viewModel.currentView {
            case .landingPage:
                ChallengeLandingPage()
            case .countDown:
                CountDownView()
            case .challengeView:
               ChallengeView()
            case .gameOver:
                GameOverScoreView(content: .score )
            }
           
        }
        .onAppear {
            viewModel.onAction(.loadQuestions)
        }
    }
}

#Preview {
    FlagChallengeMainView()
}
