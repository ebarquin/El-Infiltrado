//
//  ContentView.swift
//  El Infiltrado
//
//  Created by Eugenio Barquin on 26/11/25.
//

import SwiftUI

struct PlayerCardView: View {
    let avatar: String
    let isImpostor: Bool
    let conceptText: String
    @Binding var angle: Double
    let onFlipCompleted: () -> Void
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(Color.clear)
            ZStack {
                VStack {
                    Spacer()
                    Text(avatar)
                        .font(.system(size: 170))
                    Text("Tap to reveal your role")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .opacity(angle <= 90 ? 1 : 0)
                .rotation3DEffect(.degrees(0), axis: (x: 0, y: 1, z: 0))

                VStack {
                    Spacer()
                    Text(avatar)
                        .font(.system(size: 170))
                    Group {
                        if isImpostor {
                            Text("You are the impostor!")
                                .font(.title.bold())
                                .foregroundColor(.red)
                            Text("🤫")
                                .font(.system(size: 100))
                        } else {
                            Text("The secret word is:")
                                .font(.headline)
                            Text(conceptText)
                                .font(.largeTitle.bold())
                                .foregroundColor(.blue)
                                .minimumScaleFactor(0.5)
                                .padding(.horizontal, 18)
                        }
                    }
                    Text("Tap to hide and pass the phone 📲")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .opacity(angle > 90 ? 1 : 0)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            }
        }
        .frame(maxWidth: 350, minHeight: 320)
        .rotation3DEffect(.degrees(angle), axis: (x: 0, y: 1, z: 0))
        .contentShape(Rectangle())
        .onTapGesture {
            guard !isAnimating else { return }
            if angle == 0 {
                isAnimating = true
                withAnimation(.spring()) {
                    angle = 180
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.32) {
                    isAnimating = false
                }
            } else if angle == 180 {
                isAnimating = true
                withAnimation(.spring()) {
                    angle = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.32) {
                    isAnimating = false
                    onFlipCompleted()
                }
            }
        }
    }
}

struct GameView: View {
    private let cardColors: [Color] = [
        .blue.opacity(0.18), .green.opacity(0.20), .orange.opacity(0.19),
        .pink.opacity(0.17), .purple.opacity(0.17), .mint.opacity(0.17),
        .yellow.opacity(0.17), .teal.opacity(0.20), .indigo.opacity(0.17)
    ]
    private let personEmojis: [String] = [
        "🧑🏻", "🧑🏼", "🧑🏽", "🧑🏾", "🧑🏿",
        "👩", "👨", "👧", "👦", "🧓", "👵", "👴",
        "👩‍⚕️", "👨‍⚕️", "👩‍🎓", "👨‍🎓", "👩‍🍳", "👨‍🍳", "👩‍🚀", "👨‍🚀",
        "👩‍🔬", "👨‍🔬", "👩‍🎤", "👨‍🎤", "👩‍🏫", "👨‍🏫",
        "🧑‍🦰", "🧑‍🦱", "🧑‍🦳", "🧑‍🦲"
    ]
    let numPlayers: Int
    let onRestart: () -> Void

    @State private var concepts: [Concept] = []
    @State private var concept: Concept? = nil
    @State private var impostorIndex: Int? = nil
    @State private var revealed: [Bool] = []
    @State private var currentPage: Int = 0
    @State private var playerAvatars: [String] = []
    @State private var cardAngles: [Double] = []
    @State private var isAnimating: Bool = false

    init(numPlayers: Int, onRestart: @escaping () -> Void) {
        self.numPlayers = numPlayers
        self.onRestart = onRestart
        _revealed = State(initialValue: Array(repeating: false, count: numPlayers))
        _cardAngles = State(initialValue: Array(repeating: 0.0, count: numPlayers))
    }

    var body: some View {
        ZStack {
            // Fondo adaptativo
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                if let concept = concept, let impostorIndex = impostorIndex {
                    TabView(selection: $currentPage) {
                        ForEach(Array(0..<numPlayers), id: \.self) { index in
                            VStack {
                                Spacer()
                                
                                PlayerCardView(
                                    avatar: playerAvatars[safe: index] ?? "🧑",
                                    isImpostor: index == impostorIndex,
                                    conceptText: concept.text,
                                    angle: $cardAngles[index],
                                    onFlipCompleted: { advanceToNextPlayer(from: index) }
                                )
                                .background(
                                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                                        .fill(cardColors[index % cardColors.count])
                                        .shadow(radius: 12)
                                )
                                .padding(.bottom, 16)
                                
                                Spacer()
                            }
                            .padding()
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                } else {
                    ProgressView("Loading…")
                        .onAppear {
                            let loaded: [Concept] = ConceptRepository.loadAllConcepts()
                            concepts = loaded
                            concept = loaded.randomElement()
                            impostorIndex = Int.random(in: 0..<numPlayers)
                            revealed = Array(repeating: false, count: numPlayers)
                            cardAngles = Array(repeating: 0.0, count: numPlayers)
                            currentPage = 0
                            playerAvatars = (0..<numPlayers).map { _ in personEmojis.randomElement() ?? "🧑" }
                        }
                }

                Divider().padding(.top, 8)

                HStack {
                    Button(action: {
                        concept = concepts.randomElement()
                        impostorIndex = Int.random(in: 0..<numPlayers)
                        revealed = Array(repeating: false, count: numPlayers)
                        cardAngles = Array(repeating: 0.0, count: numPlayers)
                        currentPage = 0
                    }) {
                        Label("Play Again", systemImage: "repeat")
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.headline)

                    Spacer()

                    Button(action: {
                        onRestart()
                    }) {
                        Label("Back to Setup", systemImage: "arrowshape.turn.up.backward.fill")
                    }
                    .buttonStyle(.bordered)
                    .font(.headline)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .interactiveDismissDisabled()
    }

    private func advanceToNextPlayer(from index: Int) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        withAnimation(.easeInOut) {
            if index < numPlayers - 1 {
                currentPage = index + 1
            }
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
