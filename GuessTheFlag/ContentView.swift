//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Julian Miño on 27/08/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var highestScore = 0
    
    @State private var countries = [
        "Estonia",
        "France",
        "Germany",
        "Ireland",
        "Italy",
        "Nigeria",
        "Poland",
        "Russia",
        "Spain",
        "UK",
        "US"
    ].shuffled()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                AngularGradient(colors: [.red, .yellow, .purple, .purple, .red], center: .center)
                AngularGradient(colors: [.red, .purple, .purple, .yellow, .red], center: .center).colorInvert()
            }
            VStack(spacing: 30) {
                Text("Tap the flag of:")
                    .padding(30)
                    .foregroundStyle(.secondary)
                    .background(.thinMaterial)
                    .font(.subheadline.bold())
                    .clipShape(Capsule())
                Text(countries[correctAnswer])
                    .padding(20)
                    .foregroundStyle(.primary)
                    .background(.thickMaterial)
                    .font(.largeTitle.bold().italic())
                    .clipShape(Capsule())
                VStack(spacing: 30) {
                    ForEach(0..<3, id: \.self) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
                .padding(30)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }.alert(scoreTitle, isPresented: $showingScore, actions: {
            Button("Continue") {
                askQuestion()
            }
        }, message: {
            Text("Your current score is \(score)\n Highest score: \(highestScore)")
        })
        .ignoresSafeArea()
    }
    
    private func flagTapped(_ number: Int) {
        if number == correctAnswer {
            score += 1
            scoreTitle = "Correct"
            highestScore = score > highestScore ? score : highestScore
        } else {
            scoreTitle = "Wrong"
            score = 0
        }
        showingScore = true
    }
    
    private func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
