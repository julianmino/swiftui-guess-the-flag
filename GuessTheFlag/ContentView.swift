//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Julian Miño on 27/08/2023.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

extension View {
    func titleStyle() -> some View {
        return modifier(Title())
    }
}

struct FlagImage: View {
    var countryName: String
    
    var body: some View {
        Image(countryName)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var highestScore = 0
    
    @State private var angleDegrees = 0.0
    @State private var wrongAnswerOpacity = 1.0
    @State private var wrongAnswerScale = 1.0
    
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
                            if correctAnswer == number {
                                FlagImage(countryName: countries[number])
                                    .rotation3DEffect(.degrees(angleDegrees), axis: (x: 0, y: 1, z: 0))
                            } else {
                                FlagImage(countryName: countries[number])
                                    .opacity(wrongAnswerOpacity)
                                    .scaleEffect(wrongAnswerScale)
                            }
                        }
                    }
                }
                .padding(30)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .alert(scoreTitle, isPresented: $showingScore, actions: {
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
            withAnimation(.easeOut(duration: 0.5)) {
                angleDegrees += 360
            }
            score += 1
            scoreTitle = "Correct"
            highestScore = score > highestScore ? score : highestScore
        } else {
            scoreTitle = "Wrong"
            score = 0
        }
        withAnimation(.easeOut(duration: 0.5)) {
            wrongAnswerOpacity = 0.25
            wrongAnswerScale = 0.75
        }
        showingScore = true
    }
    
    private func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        wrongAnswerOpacity = 1
        wrongAnswerScale = 1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
