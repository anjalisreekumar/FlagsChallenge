//
//  CountDownView.swift
//  FlagsChallenge
//
//  Created by Hariom Sharma on 22/10/25.
//

import SwiftUI

struct CountDownView: View {
    @EnvironmentObject var viewModel: FlagChallengeViewModel
    @State private var remainingTime: Int = 0
    @State private var timer: Timer? = nil
    
    var body: some View {
        VStack(spacing: 12) {
            if let scheduled = viewModel.scheduledTime {
                if remainingTime > 20 {
                    Text("Challenge scheduled at \(scheduled.formatted(date: .omitted, time: .shortened))")
                        .font(.title2)
                    Text("Will start in \(timeString(from: remainingTime))")
                        .font(.headline)
                        .foregroundColor(.secondary)
                } else if remainingTime > 0 {
                    Text("Challenge will start in")
                        .font(.title2)
                    Text(timeString(from: remainingTime))
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                        .foregroundColor(.blue)
                }
            }
        }
        .onAppear {
            startTimer()
        }
    }

    private func startTimer() {
        guard let scheduled = viewModel.scheduledTime else { return }
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let diff = Int(scheduled.timeIntervalSinceNow)
            remainingTime = max(diff, 0)
            
            if diff <= 0 {
                timer?.invalidate()
                viewModel.onAction(.switchView(.challengeView))
            }
        }
    }
    
    private func timeString(from seconds: Int) -> String {
        let min = seconds / 60
        let sec = seconds % 60
        return String(format: "%02d:%02d", min, sec)
    }
}
