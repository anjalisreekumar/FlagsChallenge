//
//  FlagsChallengeApp.swift
//  FlagsChallenge
//
//  Created by Hariom Sharma on 22/10/25.
//

import SwiftUI

@main
struct FlagsChallengeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            FlagChallengeMainView(
                viewModel: FlagChallengeViewModel(context: persistenceController.container.viewContext)
            )
        }
    }
}


