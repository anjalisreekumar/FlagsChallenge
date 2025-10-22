//
//  ChallengeLandingPage.swift
//  FlagsChallenge
//
//  Created by Hariom Sharma on 22/10/25.
//

import SwiftUI

struct ChallengeLandingPage: View {
    @EnvironmentObject var viewModel: FlagChallengeViewModel
    @State var firstHour: String = "0"
    @State var secondHour: String = "0"

    @State var firstMinutes: String = "0"
    @State var secondMinutes: String = "0"

    @State var firstSeconds: String = "0"
    @State var secondSeconds: String = "0"


    var body: some View {
        VStack {
            Text("Challenge Schedule")
            HStack(spacing: 32){
                TimeUnitView(firstDigit: $firstHour, secondDigit: $secondHour, label: "Hours")
                TimeUnitView(firstDigit: $firstMinutes, secondDigit: $secondMinutes, label: "Minutes")
                TimeUnitView(firstDigit: $firstSeconds, secondDigit: $secondSeconds, label: "Seconds")
            }
            Button {
                
                let hourFormat = DateFormat(firstDigit: Int(firstHour) ?? 0,
                                            secondDigit: Int(secondHour) ?? 0,
                                            type: .hour)

                let minuteFormat = DateFormat(firstDigit: Int(firstMinutes) ?? 0,
                                              secondDigit: Int(secondMinutes) ?? 0,
                                              type: .minute)

                let secondFormat = DateFormat(firstDigit: Int(firstSeconds) ?? 0,
                                              secondDigit: Int(secondSeconds) ?? 0,
                                              type: .second)

                let scheduledDate = viewModel.scheduledDateFromDigits(hour: hourFormat, minute: minuteFormat, second: secondFormat)
                
                viewModel.onAction(.saveSchedulesTime(scheduledDate))

                //save action
               
            } label: {
                Text("Save")
                    .foregroundStyle(Color.white)
                    .bold()
            }
            .buttonStyle(.borderedProminent)

        }
        .onAppear {
            viewModel.fetchCoreDataData()
        }
    }
}

#Preview {
    ChallengeLandingPage()
}

struct TitleCard: View {
    var body: some View {
        ZStack {
            HStack {
                ZStack {
                    Color.black
                    
                    Text("00:00")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 10, x: 0, y: 0)
                        .bold()
                }
                .frame(width: 80, height: 60)
                .cornerRadius(8)
                
                Spacer()
                Text("FLAGS CHALLENGE")
                    .font(.system(size: 28))
                    .bold()
                    .foregroundStyle(Color.accent)
                Spacer()
            }

        }
        .frame(height: 60)
        .padding(.horizontal)
    }
}


struct DigitTextField: View {
    @Binding var value: String
    
    var body: some View {
        TextField("", text: $value)
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .font(.system(size: 18, weight: .bold))
            .frame(width: 30, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .onChange(of: value) { _, newValue in
                if newValue.count > 1 {
                    value = String(newValue.prefix(1))
                }
            }
    }
}


struct TimeUnitView: View {
    @Binding var firstDigit: String
    @Binding var secondDigit: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            HStack(spacing: 4) {
                DigitTextField(value: $firstDigit)
                DigitTextField(value: $secondDigit)
            }
            
        }
    }
}
