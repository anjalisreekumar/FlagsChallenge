//
//  ChallengeLandingPage.swift
//  FlagsChallenge
//
//  Created by Hariom Sharma on 22/10/25.
//

import SwiftUI

struct ChallengeLandingPage: View {
    @State var time: String = "0"
    var body: some View {
        VStack {
            Text("Challenge Schedule")
            
            HStack(spacing: 32){
                TimeUnitView(firstDigit: $time, secondDigit: $time, label: "Hours")
                TimeUnitView(firstDigit: $time, secondDigit: $time, label: "Minutes")
                TimeUnitView(firstDigit: $time, secondDigit: $time, label: "Seconds")
            }
            Button {
                //save action
            } label: {
                Text("Save")
                    .foregroundStyle(Color.white)
                    .bold()
            }
            .buttonStyle(.borderedProminent)

            
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
                    
                    Text("00:10")
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
