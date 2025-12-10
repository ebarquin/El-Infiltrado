//
//  Concept.swift
//  El Infiltrado
//
//  Created by Eugenio Barquin on 25/11/25.
//

import Foundation
import Foundation

/// Represents a concept or word used during a game.
/// The schema definition is aligned with the concepts.json file.
struct Concept: Identifiable, Codable, Hashable {
    /// Unique identifier within the JSON file.
    let id: Int

    /// Text shown to the players (word or concept).
    let text: String

    /// Spanish version of the concept text.
    let text_es: String

    /// English version of the concept text.
    let text_en: String

    /// Logical category of the concept (e.g., "place", "event", "activity"...).
    /// Optional; can be omitted in the JSON if not applicable.
    let category: String?

    /// ISO 639-1 language code (e.g., "es", "en").
    /// Optional; if absent, the app’s default language is assumed.
    let language: String?

    /// Returns the concept text in the correct language based on the device locale.
    var localizedText: String {
        let code = Locale.current.language.languageCode?.identifier ?? "en"
        switch code {
        case "es":
            return text_es
        case "en":
            return text_en
        default:
            return text_en
        }
    }
}
