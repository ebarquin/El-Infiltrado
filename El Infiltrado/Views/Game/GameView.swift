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
    let backgroundColors: [Color]
    @Binding var angle: Double
    let onFlipCompleted: () -> Void
    @State private var isAnimating = false
    @State private var bounce = false
    @State private var tiltAngle: Double = 0

    func runTiltCycle() {
        // 1 - Left
        withAnimation(.easeInOut(duration: 0.18)) {
            tiltAngle = -8
        }

        // 2 - Right
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
            withAnimation(.easeInOut(duration: 0.18)) {
                tiltAngle = 8
            }
        }

        // 3 - Left again
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.36) {
            withAnimation(.easeInOut(duration: 0.18)) {
                tiltAngle = -8
            }
        }

        // 4 - Right again
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.54) {
            withAnimation(.easeInOut(duration: 0.18)) {
                tiltAngle = 8
            }
        }

        // 5 - Back to center
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.72) {
            withAnimation(.easeInOut(duration: 0.20)) {
                tiltAngle = 0
            }
        }

        // 6 - Pause before restarting cycle
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            runTiltCycle()
        }
    }

    var body: some View {
        ZStack {
            // Background card with cartoon look
            RoundedRectangle(cornerRadius: 40, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: backgroundColors,
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 40, style: .continuous)
                        .stroke(Color.white.opacity(0.9), lineWidth: 4)
                )
                .overlay(
                    Circle()
                        .stroke(backgroundColors.first ?? .white, lineWidth: 12)
                        .blur(radius: 20)
                        .opacity(0.35)
                )
                .shadow(color: .black.opacity(0.15), radius: 10, x: 6, y: 6)

            ZStack {
                // Front side: before reveal
                VStack(spacing: 16) {
                    Spacer()

                    Image(avatar)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white.opacity(0.9), lineWidth: 4)
                        )
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 4, y: 4)
                        .frame(width: 160, height: 160)

                    Text(NSLocalizedString("tap_reveal_role", comment: ""))
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 2, y: 2)
                        .padding(.top, 8)

                    Spacer()
                }
                .padding(.horizontal, 24)
                .opacity(angle <= 90 ? 1 : 0)
                .rotation3DEffect(.degrees(0), axis: (x: 0, y: 1, z: 0))

                // Back side: after reveal
                VStack(spacing: 18) {
                    Spacer()

                    Image(avatar)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white.opacity(0.9), lineWidth: 4)
                        )
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 4, y: 4)
                        .frame(width: 115, height: 115)

                    Group {
                        if isImpostor {
                            Text(NSLocalizedString("role_impostor", comment: ""))
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .shadow(color: .white.opacity(0.35), radius: 6, x: 0, y: 0)
                                .padding(.top, 4)

                            Image("shh_lips")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 115, height: 115)
                                .shadow(color: .white.opacity(0.25), radius: 5, x: 0, y: 0)
                                .padding(.top, -4)
                        } else {
                            Text(NSLocalizedString("secret_word_is", comment: ""))
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(.white.opacity(0.9))
                                .shadow(color: .black.opacity(0.25), radius: 3, x: 2, y: 2)

                            Text(conceptText)
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.35), radius: 4, x: 2, y: 3)
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 18)
                        }
                    }

                    Text(NSLocalizedString("tap_hide_pass_phone", comment: ""))
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .shadow(color: .black.opacity(0.25), radius: 3, x: 1, y: 2)

                    Image("tap_pass_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 100)
                        .opacity(0.97)
                        .shadow(color: .black.opacity(0.35), radius: 6, x: 2, y: 3)
                        .rotationEffect(.degrees(tiltAngle))
                        .padding(.top, 12)

                    Spacer()
                }
                .padding(.horizontal, 24)
                .opacity(angle > 90 ? 1 : 0)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .onAppear {
                    bounce = true
                    runTiltCycle()
                }
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
    private let animalAvatars: [String] = [
        "avatar_dog",
        "avatar_bear",
        "avatar_rabbit",
        "avatar_panda",
        "avatar_tiger",
        "avatar_koala",
        "avatar_penguin"
    ]
    private let cardColorPalettes: [[Color]] = [
        [.pink.opacity(0.9), .orange.opacity(0.85)],
        [.purple.opacity(0.88), .blue.opacity(0.85)],
        [.yellow.opacity(0.95), .mint.opacity(0.85)],
        [.blue.opacity(0.92), .teal.opacity(0.85)],
        [.orange.opacity(0.9), .red.opacity(0.85)],
        [.green.opacity(0.9), .yellow.opacity(0.85)],
        [.mint.opacity(0.9), .cyan.opacity(0.85)],
        [.indigo.opacity(0.9), .purple.opacity(0.85)]
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
    @State private var cardBackgrounds: [[Color]] = []

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
                                    avatar: playerAvatars[safe: index] ?? animalAvatars.first!,
                                    isImpostor: index == impostorIndex,
                                    conceptText: concept.localizedText,
                                    backgroundColors: cardBackgrounds[safe: index] ?? [.yellow, .orange],
                                    angle: $cardAngles[index],
                                    onFlipCompleted: { advanceToNextPlayer(from: index) }
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
                    ProgressView(NSLocalizedString("loading", comment: ""))
                        .onAppear {
                            let loaded: [Concept] = ConceptRepository.loadAllConcepts()
                            concepts = loaded
                            concept = loaded.randomElement()
                            impostorIndex = Int.random(in: 0..<numPlayers)
                            revealed = Array(repeating: false, count: numPlayers)
                            cardAngles = Array(repeating: 0.0, count: numPlayers)
                            currentPage = 0
                            playerAvatars = Array(animalAvatars.shuffled().prefix(numPlayers))
                            cardBackgrounds = Array(cardColorPalettes.shuffled().prefix(numPlayers))
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
                        playerAvatars = Array(animalAvatars.shuffled().prefix(numPlayers))

                    }) {
                        Label(NSLocalizedString("button_play_again", comment: ""), systemImage: "repeat")
                    }
                    .buttonStyle(CartoonButtonStyle())
                    .font(.headline)

                    Spacer()

                    Button(action: {
                        onRestart()
                    }) {
                        Label(NSLocalizedString("button_back_setup", comment: ""), systemImage: "arrowshape.turn.up.backward.fill")
                    }
                    .buttonStyle(CartoonButtonStyle())
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

struct CartoonButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.headline, design: .rounded).bold())
            .padding(.vertical, 14)
            .padding(.horizontal, 24)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(
                        LinearGradient(
                            colors: [.orange.opacity(0.95), .yellow.opacity(0.9)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .stroke(Color.white.opacity(0.35), lineWidth: 2)
                    .blur(radius: 2)
                    .offset(y: -2)
                    .mask(
                        RoundedRectangle(cornerRadius: 28)
                            .padding(.bottom, 26)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .shadow(color: .black.opacity(0.2), radius: 6, x: 3, y: 4)
            .animation(.spring(response: 0.25, dampingFraction: 0.55), value: configuration.isPressed)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .shadow(color: .black.opacity(0.15), radius: 6, x: 4, y: 4)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: configuration.isPressed)
    }
}
