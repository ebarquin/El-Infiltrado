//
//  ConceptRepostory.swift
//  El Infiltrado
//
//  Created by Eugenio Barquin on 26/11/25.
//

import Foundation

enum ConceptRepository {
    static func loadAllConcepts() -> [Concept] {
        guard let url = Bundle.main.url(forResource: "concepts", withExtension: "json") else {
            assertionFailure("concepts.json not found in bundle.")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            let concepts = try JSONDecoder().decode([Concept].self, from: data)
            return concepts.filter { !$0.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        } catch {
            assertionFailure("Failed to load or decode concepts.json: \(error)")
            return []
        }
    }
}
