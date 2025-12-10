//
//  ContentView.swift
//  El Infiltrado
//
//  Created by Eugenio Barquin on 25/11/25.
//

import SwiftUI

struct ContentView: View {
    // Estado: número de jugadores, conceptos y selección
    @State private var numPlayers: Int = 5
    @State private var concepts: [Concept] = []
    @State private var selectedConcept: Concept?
    @State private var showGame = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Text(NSLocalizedString("title_main", comment: ""))
                    .font(.system(size: 44, weight: .heavy, design: .rounded))
                    .foregroundColor(.black)
                    .shadow(color: .orange.opacity(0.35), radius: 4, x: 0, y: 3)
                    .padding(.top, 4)
                
                Text(NSLocalizedString("subtitle_select_players", comment: ""))
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(Color.orange.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                HStack(spacing: 16) {
                    Text(NSLocalizedString("label_players", comment: ""))
                        .font(.system(size: 22, weight: .semibold, design: .rounded))

                    Button(action: { if numPlayers > 3 { numPlayers -= 1 } }) {
                        Image(systemName: "minus")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(
                                        LinearGradient(colors: [.orange, .yellow], startPoint: .top, endPoint: .bottom)
                                    )
                            )
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 3)
                            )
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 2, y: 3)
                    }

                    Text("\(numPlayers)")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .frame(width: 40)

                    Button(action: { if numPlayers < 8 { numPlayers += 1 } }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(
                                        LinearGradient(colors: [.orange, .yellow], startPoint: .top, endPoint: .bottom)
                                    )
                            )
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 3)
                            )
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 2, y: 3)
                    }
                }
                
                Button {
                    if let concept = concepts.randomElement() {
                        selectedConcept = concept
                        showGame = true
                    }
                } label: {
                    Text(NSLocalizedString("button_start_game", comment: ""))
                        .font(.system(.headline, design: .rounded).bold())
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(CartoonButtonStyle())
                .padding(.horizontal)
                .disabled(concepts.isEmpty || numPlayers < 3)
                
                Spacer()
            }
            .padding()
            .sheet(isPresented: $showGame, onDismiss: {
                selectedConcept = nil
            }) {
                GameView(numPlayers: numPlayers, onRestart: {
                    showGame = false
                })
            }
        }
        .onAppear {
            // Cargar conceptos una vez al abrir la pantalla
            concepts = ConceptRepository.loadAllConcepts()
        }
    }
}

#Preview {
    ContentView()
}
