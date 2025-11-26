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
            VStack(spacing: 24) {
                Text("El Infiltrado")
                    .font(.largeTitle.bold())
                    .padding(.top)
                
                // Selector de número de jugadores
                HStack {
                    Text("Players:")
                    Stepper(value: $numPlayers, in: 3...8) {
                        Text("\(numPlayers)")
                            .font(.title3)
                            .bold()
                    }
                    .frame(width: 180)
                }
                
                // Botón para empezar la partida (de momento solo print)
                Button {
                    if let concept = concepts.randomElement() {
                        selectedConcept = concept
                        showGame = true
                    }
                } label: {
                    Text("Start Game")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
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
