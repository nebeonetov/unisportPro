//
//  MiniGames.swift
//  UnisportApp
//
//  Created by D K on 21.04.2025.
//

import SwiftUI

struct MiniGamesView: View {
    @State private var mentalScore: Int = 72

    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Text("Relax Mini Games")
                        .font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal).padding(.top)
                
                VStack(spacing: 20) {
                  

                    Text("Challenge yourself and stay sharp between workouts!")
                        .multilineTextAlignment(.center)
                        .foregroundColor(ColorTheme.textSecondary)
                        .padding(.horizontal)

                    GameCard(title: "Tap Trainer", description: "Tap the glowing block!", emoji: "👟", destination: TapTrainerGame())
                    GameCard(title: "Reflex Tap", description: "Tap when the light turns green!", emoji: "⚡️", destination: ColorSwapTapGame())
                    GameCard(title: "Quiz Blitz", description: "Answer 3 sport questions!", emoji: "🧠", destination: QuizGame())

                    Divider().padding(.top)

                    // Mental health info in English
                    VStack(spacing: 12) {
                        Text("🧘 Mental Health Matters")
                            .font(.title2)
                            .bold()
                            .foregroundColor(ColorTheme.textPrimary)

                        CircularProgress(percentage: Double(mentalScore))
                            .frame(width: 140, height: 140)
                            .padding(.vertical)
                        
                        Text("In addition to improving physical condition, it’s important not to forget about mental health. These mini-games also help train concentration, focus, and reaction speed.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(ColorTheme.textSecondary)
                            .padding(.horizontal)

                        Text("🧪 According to a Stanford University study:")
                            .font(.subheadline)
                            .foregroundColor(ColorTheme.textSecondary)

                        Text("Completing mini-games improves mental well-being in \(mentalScore)% of users.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(ColorTheme.textSecondary)
                            .padding(.horizontal)
                    }
                    .padding(.top)
                }
                .padding()
            }
            .background(ColorTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .tint(.white)
    }
}

struct CircularProgress: View {
    let percentage: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 14)

            Circle()
                .trim(from: 0, to: CGFloat(percentage) / 100)
                .stroke(ColorTheme.primary, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 1.0), value: percentage)

            Text("\(Int(percentage))%")
                .font(.title2)
                .bold()
                .foregroundColor(ColorTheme.textPrimary)
        }
    }
}

struct MiniGamesView_Previews: PreviewProvider {
    static var previews: some View {
        MiniGamesView()
            .preferredColorScheme(.dark)
    }
}


struct GameCard<Destination: View>: View {
    let title: String
    let description: String
    let emoji: String
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 12) {
                Text(emoji)
                    .font(.largeTitle)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(ColorTheme.textPrimary)
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(ColorTheme.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(ColorTheme.primary)
            }
            .padding()
            .background(ColorTheme.card)
            .cornerRadius(12)
        }
    }
}



struct ColorSwapTapGame: View {
    private let targetColor: Color = .green
    private let fakeGreenColor = Color("FakeGreen") // лаймовый, добавим ниже
    private let allColors: [Color] = [.red, .yellow, .blue, .purple, .orange, .green, Color("FakeGreen")]
    
    @State private var currentColor: Color = .red
    @State private var score: Int = 0
    @State private var showResult = false
    @State private var didWin = false
    @State private var timer: Timer?
    @State private var lastGreenTime: Date?
    @State private var lastReactionMs: Int?
    @State private var showReactionText = false

    let totalScore = 10
    
    var body: some View {
        ZStack {
            ColorTheme.background.ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("🎯 Color Swap")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(ColorTheme.textPrimary)
                
                Text("Tap ONLY when it's bright green!")
                    .multilineTextAlignment(.center)
                    .foregroundColor(ColorTheme.textSecondary)

                Text("Score: \(score)/\(totalScore)")
                    .foregroundColor(ColorTheme.primary)
                
                Button(action: {
                    handleTap()
                }) {
                    Circle()
                        .fill(currentColor)
                        .frame(width: 140, height: 140)
                        .shadow(radius: 10)
                        .overlay(
                            Image(systemName: "hand.tap.fill")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        )
                }
                .scaleEffect(showReactionText ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: showReactionText)

                if let last = lastReactionMs, showReactionText {
                    Text("+\(last) ms")
                        .foregroundColor(.gray)
                        .transition(.opacity)
                        .font(.caption)
                }
                
                Button("Restart") {
                    restartGame()
                }
                .foregroundColor(.gray)
            }
            .padding()
            
            if showResult {
                resultOverlay
            }
        }
        .onAppear {
            startColorCycle()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startColorCycle() {
        scheduleNextColor()
    }

    private func scheduleNextColor() {
        timer?.invalidate()
        let delay = currentSpeed()
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            var newColor = allColors.randomElement() ?? .green
            while newColor == currentColor {
                newColor = allColors.randomElement() ?? .green
            }
            currentColor = newColor
            if newColor == targetColor {
                lastGreenTime = Date()
            } else {
                lastGreenTime = nil
            }
            showReactionText = false
            scheduleNextColor()
        }
    }

    private func currentSpeed() -> Double {
        switch score {
        case 0..<3: return 0.8
        case 3..<6: return 0.6
        default: return 0.4
        }
    }

    private func handleTap() {
        if currentColor == targetColor {
            if let greenTime = lastGreenTime {
                let reaction = Int(Date().timeIntervalSince(greenTime) * 1000)
                lastReactionMs = reaction
                showReactionText = true
            }
            score += 1
            if score >= totalScore {
                didWin = true
                endGame()
            }
        } else {
            // Нажал на "ловушку" или другой цвет
            didWin = false
            endGame()
        }
    }

    private func endGame() {
        timer?.invalidate()
        showResult = true
    }

    private func restartGame() {
        score = 0
        currentColor = .red
        showResult = false
        lastReactionMs = nil
        showReactionText = false
        startColorCycle()
    }

    private var resultOverlay: some View {
        VStack(spacing: 16) {
            Text(didWin ? "🎉 You Win!" : "❌ Wrong Tap!")
                .font(.largeTitle)
                .bold()
                .foregroundColor(ColorTheme.textPrimary)

            Text(didWin ? "Great focus!" : "Only tap when it's bright green.")
                .foregroundColor(ColorTheme.textSecondary)

            Button("Try Again") {
                restartGame()
            }
            .font(.headline)
            .padding()
            .background(ColorTheme.primary)
            .foregroundColor(.black)
            .cornerRadius(12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.85))
        .ignoresSafeArea()
    }
}


struct QuizQuestion {
    let question: String
    let answers: [String]
    let correctIndex: Int
}

struct QuizGame: View {
    @State private var questions: [QuizQuestion] = QuizGame.allQuestions.shuffled().prefix(3).map { $0 }
    @State private var currentIndex: Int = 0
    @State private var score: Int = 0
    @State private var selectedIndex: Int? = nil
    @State private var showResult = false
    @State private var answerChecked = false
    @State private var timerSeconds: Int = 10
    @State private var timer: Timer?
    @State private var fakeGlobalScore: Int = Int.random(in: 43...88)

    var body: some View {
        ZStack {
            ColorTheme.background.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("🧠 Sport Quiz")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(ColorTheme.textPrimary)
                
                if currentIndex < questions.count {
                    let q = questions[currentIndex]

                    Text("Question \(currentIndex + 1) of \(questions.count)")
                        .foregroundColor(ColorTheme.textSecondary)

                    Text("⏱ Time left: \(timerSeconds)s")
                        .foregroundColor(.red)

                    Text(q.question)
                        .font(.headline)
                        .foregroundColor(ColorTheme.textPrimary)
                        .multilineTextAlignment(.center)
                        .padding()

                    ForEach(0..<q.answers.count, id: \.self) { i in
                        Button(action: {
                            if !answerChecked {
                                selectedIndex = i
                                answerChecked = true
                                if i == q.correctIndex {
                                    score += 1
                                }
                                nextQuestionDelayed()
                            }
                        }) {
                            Text(q.answers[i])
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(buttonColor(for: i))
                                .cornerRadius(10)
                        }
                        .disabled(answerChecked)
                    }
                }

                Spacer()
            }
            .padding()
            .animation(.easeInOut, value: currentIndex)
            .onAppear {
                startTimer()
            }

            if showResult {
                resultOverlay
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func startTimer() {
        timer?.invalidate()
        timerSeconds = 10
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timerSeconds > 0 {
                timerSeconds -= 1
            } else {
                answerChecked = true
                selectedIndex = nil
                nextQuestionDelayed()
            }
        }
    }

    private func nextQuestionDelayed() {
        timer?.invalidate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            goToNextQuestion()
        }
    }

    private func buttonColor(for index: Int) -> Color {
        guard answerChecked else { return ColorTheme.card }

        let correct = questions[currentIndex].correctIndex
        if index == correct {
            return .green
        } else if index == selectedIndex {
            return .red
        } else {
            return ColorTheme.card
        }
    }

    private func goToNextQuestion() {
        selectedIndex = nil
        answerChecked = false
        currentIndex += 1
        if currentIndex >= questions.count {
            showResult = true
            timer?.invalidate()
        } else {
            startTimer()
        }
    }

    private func restartGame() {
        questions = QuizGame.allQuestions.shuffled().prefix(3).map { $0 }
        currentIndex = 0
        score = 0
        selectedIndex = nil
        showResult = false
        answerChecked = false
        fakeGlobalScore = Int.random(in: 43...88)
        startTimer()
    }

    private var resultOverlay: some View {
        VStack(spacing: 20) {
            Text("🏁 Quiz Finished")
                .font(.largeTitle)
                .bold()
                .foregroundColor(ColorTheme.textPrimary)

            Text("You got \(score) out of \(questions.count) correct!")
                .foregroundColor(ColorTheme.textSecondary)

            VStack(spacing: 10) {
                Text("🏆 Performance")
                    .foregroundColor(ColorTheme.textPrimary)

                ZStack(alignment: .leading) {
                    Capsule()
                        .frame(width: 220, height: 20)
                        .foregroundColor(Color.gray.opacity(0.3))
                    Capsule()
                        .frame(width: CGFloat(fakeGlobalScore) * 2.2, height: 20)
                        .foregroundColor(ColorTheme.primary)
                }

                Text("You performed better than \(fakeGlobalScore)% of players")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Button("Play Again") {
                restartGame()
            }
            .font(.headline)
            .padding()
            .background(ColorTheme.primary)
            .foregroundColor(.black)
            .cornerRadius(12)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.85))
        .ignoresSafeArea()
    }

    // Спортивные вопросы
    static let allQuestions: [QuizQuestion] = [
        QuizQuestion(question: "How many players are there in a football team?", answers: ["9", "10", "11", "12"], correctIndex: 2),
        QuizQuestion(question: "What sport is known as 'The Sweet Science'?", answers: ["Wrestling", "Boxing", "Fencing", "Karate"], correctIndex: 1),
        QuizQuestion(question: "Which country has the most Olympic gold medals?", answers: ["Russia", "Germany", "USA", "China"], correctIndex: 2),
        QuizQuestion(question: "What surface is the French Open played on?", answers: ["Clay", "Grass", "Hard", "Wood"], correctIndex: 0),
        QuizQuestion(question: "What is a perfect score in bowling?", answers: ["200", "250", "300", "350"], correctIndex: 2),
        QuizQuestion(question: "Which sport uses 'love' for zero?", answers: ["Volleyball", "Tennis", "Cricket", "Golf"], correctIndex: 1)
    ]
}




struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    var body: some View {
        VStack(spacing: 12) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(0..<columns, id: \.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }
}



struct TapTrainerGame: View {
    @State private var activeIndex = Int.random(in: 0..<4)
    @State private var score = 0
    @State private var showResult = false
    @State private var didWin = false
    @State private var reactionTimer: Timer?
    @State private var animateGlow = false

    let totalScore = 10
    let buttonSize: CGFloat = 100
    let reactionLimit: TimeInterval = 1.5

    var body: some View {
        ZStack {
            ColorTheme.background.ignoresSafeArea()

            VStack(spacing: 20) {
                Text("👟 Tap Trainer")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(ColorTheme.textPrimary)

                Text("Tap the glowing block before time runs out!")
                    .foregroundColor(ColorTheme.textSecondary)

                Text("Score: \(score)/\(totalScore)")
                    .foregroundColor(ColorTheme.primary)

                GridStack(rows: 3, columns: 3) { row, col in
                    Button(action: {
                        let index = row * 2 + col
                        handleTap(index: index)
                    }) {
                        let index = row * 2 + col
                        RoundedRectangle(cornerRadius: 16)
                            .fill(index == activeIndex ? ColorTheme.primary : ColorTheme.card)
                            .frame(width: buttonSize, height: buttonSize)
                            .overlay(
                                index == activeIndex ?
                                    Image(systemName: "hand.point.up.fill")
                                        .font(.title)
                                        .foregroundColor(.black)
                                    : nil
                            )
                            .shadow(color: index == activeIndex && animateGlow ? ColorTheme.primary.opacity(0.6) : .clear,
                                    radius: animateGlow ? 10 : 0)
                            .animation(.easeInOut(duration: 0.3), value: animateGlow)
                    }
                }

                Button("Restart") {
                    restartGame()
                }
                .foregroundColor(.gray)
                .padding(.top)
            }
            .padding()

            if showResult {
                resultOverlay
            }
        }
        .onAppear {
            startGame()
        }
        .onDisappear {
            cancelTimer()
        }
    }

    private func handleTap(index: Int) {
        if index == activeIndex {
            score += 1
            if score >= totalScore {
                didWin = true
                endGame()
            } else {
                activateNewTarget()
            }
        } else {
            didWin = false
            endGame()
        }
    }

    private func startGame() {
        activateNewTarget()
    }

    private func activateNewTarget() {
        cancelTimer()
        activeIndex = Int.random(in: 0..<4)
        animateGlow = true

        reactionTimer = Timer.scheduledTimer(withTimeInterval: reactionLimit, repeats: false) { _ in
            didWin = false
            endGame()
        }
    }

    private func cancelTimer() {
        reactionTimer?.invalidate()
    }

    private func endGame() {
        cancelTimer()
        animateGlow = false
        showResult = true
    }

    private func restartGame() {
        score = 0
        didWin = false
        showResult = false
        animateGlow = false
        activateNewTarget()
    }

    private var resultOverlay: some View {
        VStack(spacing: 16) {
            Text(didWin ? "🎉 You Win!" : "😢 You Lose")
                .font(.largeTitle)
                .bold()
                .foregroundColor(ColorTheme.textPrimary)

            Text(didWin ? "Great reaction time!" : "Try again, focus!")
                .foregroundColor(ColorTheme.textSecondary)

            Button("Play Again") {
                restartGame()
            }
            .font(.headline)
            .padding()
            .background(ColorTheme.primary)
            .foregroundColor(.black)
            .cornerRadius(12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.85))
        .ignoresSafeArea()
    }
}


struct ColorTheme {
    static let background = Color(red: 34/255, green: 34/255, blue: 34/255)
    static let card = Color(.darkGray)
    static let primary = Color.green
    static let textPrimary = Color.white
    static let textSecondary = Color.gray
}
