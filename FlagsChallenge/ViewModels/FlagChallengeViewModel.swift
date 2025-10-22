//
//  FlagChallengeViewModel.swift
//  FlagsChallenge
//
//  Created by Hariom Sharma on 22/10/25.
//

import Foundation

enum ScreenType {
    case landingPage
    case countDown
    case challengeView
    case gameOver
}

enum ActionType {
    case switchView(ScreenType)
    case loadQuestions
    
}
final class FlagChallengeViewModel: ObservableObject {
    
    @Published var currentView: ScreenType = .landingPage
    
    func onAction(_ action: ActionType) {
        switch action {
        case .switchView(let type):
            switchViewTo(type)
        case .loadQuestions:
            loadDataFromJson()
        }
    }
    
    private func switchViewTo(_ type: ScreenType) {
        currentView = type
    }
    
    private func loadDataFromJson() {
        guard let url = Bundle.main.url(forResource: "flags-challenge", withExtension: "json") else {
            print("Could not load json file from project")
            return
        }
        do {
            let content = try Data(contentsOf: url)
            let decorder = JSONDecoder()
            let questionsArray = try decorder.decode(QuestionResult.self, from: content)
            print("Decoded data from json is \(questionsArray)")
        }
        catch {
            print("Something went wrong while decoding json \(error)")
        }
        
    }
    
}
