//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Uriel Ortega on 03/04/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var score = 0
    
    @State private var numberOfQuestion = 1
    
    @State private var showingFinalMessage = false
    private var endgameTitle = "Game over!"
    @State private var endgameMessage = ""
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    struct FlagImage: View {
        var country: String
        
        var body: some View {
            Image(country)
                .renderingMode(.original)
                .clipShape(Capsule())
                .shadow(radius: 5)
        }
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            
            VStack {
                Spacer()
                
                Text("Guess the flag")
                    .font(.largeTitle.bold()) // Same as .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                
                Text("Question \(numberOfQuestion)/8")
                    .foregroundStyle(.white)
                    .font(.subheadline)
                    .animation(.default, value: numberOfQuestion)

                Spacer()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of...")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(country: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                    .animation(.default, value: score)
                                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(scoreMessage)
        }
        .alert(endgameTitle, isPresented: $showingFinalMessage) {
            Button("Restart", action: reset)
        } message: {
            Text(endgameMessage)
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            score += 1
            
            scoreTitle = "Correct"
            scoreMessage = "Your score is \(score)"
        } else {
            scoreTitle = "Wrong"
            scoreMessage = "That's the flag of \(countries[number])"
        }
        
        if numberOfQuestion > 7 {
            endgameMessage = "Your final score is \(score)"
            
            showingFinalMessage = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        numberOfQuestion += 1

        correctAnswer = Int.random(in: 0...2)
    }
    
    func reset() {
        score = 0
        numberOfQuestion = 0
        
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
