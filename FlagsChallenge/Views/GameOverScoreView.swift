//
//  GameOverScoreView.swift
//  FlagsChallenge
//
//  Created by Hariom Sharma on 22/10/25.
//

import SwiftUI

enum GameOverViewType {
    case gameOver
    case score
}
struct GameOverScoreView: View {
    @State var content: GameOverViewType = .score
    var body: some View {
        ZStack {
            switch content {
            case .gameOver:
               GameOverView()
            case .score:
                ScoreView()
            }
        }
    }
}

#Preview {
    GameOverScoreView()
}

struct GameOverView: View {
    var body: some View {
        Text("Game Over")
            .font(.title)
            .bold()
    }
}

struct ScoreView: View {
    var body: some View {
        HStack {
            Text("Score: ")
                .foregroundStyle(Color.accent)
                .font(.system(.headline))
                .bold()
            
            Text("70/100")
                .bold()
        }
    }
}
