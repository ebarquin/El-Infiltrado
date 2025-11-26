//
//  ContentView.swift
//  El Infiltrado
//
//  Created by Eugenio Barquin on 26/11/25.
//

import SwiftUI

struct GameView: View {
    let numPlayers: Int
    let onRestart: () -> Void

    @State private var concepts: [Concept] = []
    @State private var concept: Concept?
    @State private var impostorIndex: Int?
    @State private var revealed: [Bool]
    @State private var currentPage = 0

    init(numPlayers: Int, onRestart: @escaping () -> Void) {
        self.numPlayers = numPlayers
        self.onRestart = onRestart
        _revealed = State(initialValue: Array(repeating: false, count: numPlayers))
    }

    var body: some View {
        VStack(spacing: 16) {
            if let concept = concept, let impostorIndex = impostorIndex {
                TabView(selection: $currentPage) {
                    ForEach(0..<numPlayers, id: \.self) { index in
                        VStack {
                            Spacer()

                            if !revealed[index] {
                                // Estado oculto
                                Text("👀")
                                    .font(.system(size: 120))
                                    .onTapGesture {
                                        revealed[index] = true
                                    }
                                Text("Tap to reveal your role")
                                    .foregroundColor(.secondary)
                                    .padding(.top, 8)

                            } else {
                                // Estado revelado
                                Group {
                                    if index == impostorIndex {
                                        Text("You are the impostor!")
                                            .font(.largeTitle.bold())
                                            .foregroundColor(.red)
                                        Text("🤫")
                                            .font(.system(size: 100))
                                    } else {
                                        Text("The secret word is:")
                                            .font(.headline)
                                        Text(concept.text)
                                            .font(.largeTitle.bold())
                                            .foregroundColor(.blue)
                                    }
                                }
                                .onTapGesture {
                                    revealed[index] = false
                                    advanceToNextPlayer(from: index)
                                }

                                Text("Tap to hide and pass the phone")
                                    .foregroundColor(.secondary)
                                    .padding(.top, 8)
                            }

                            Spacer()

                            Text("Player \(index + 1) of \(numPlayers)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.bottom, 40) // Prevents overlap with page indicators
                        }
                        .padding()
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                
            } else {
                ProgressView("Loading…")
                    .onAppear {
                        let loaded = ConceptRepository.loadAllConcepts()
                        concepts = loaded
                        concept = loaded.randomElement()
                        impostorIndex = Int.random(in: 0..<numPlayers)
                        revealed = Array(repeating: false, count: numPlayers)
                        currentPage = 0
                    }
            }

            Divider().padding(.top, 8)

            HStack {
                Button("Play Again") {
                    concept = concepts.randomElement()
                    impostorIndex = Int.random(in: 0..<numPlayers)
                    revealed = Array(repeating: false, count: numPlayers)
                    currentPage = 0
                }
                .buttonStyle(.borderedProminent)

                Spacer()

                Button("Back to Setup") {
                    onRestart()
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)
        }
        .padding()
        .interactiveDismissDisabled()
    }

    private func advanceToNextPlayer(from index: Int) {
        if index < numPlayers - 1 {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            withAnimation(.easeInOut) {
                currentPage = index + 1
            }
        }
    }
}
