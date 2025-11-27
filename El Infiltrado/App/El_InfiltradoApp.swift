//
//  El_InfiltradoApp.swift
//  El Infiltrado
//
//  Created by Eugenio Barquin on 25/11/25.
//

import SwiftUI

@main
struct El_InfiltradoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        let concepts = ConceptRepository.loadAllConcepts()
        print("Loaded concepts: \(concepts.count)")
        // Si quieres ver uno:
        if let random = concepts.randomElement() {
            print("Random concept example: \(random)")
        }
    }
}
