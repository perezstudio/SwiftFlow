//
//  AppSettingsModel.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 5/28/24.
//

import SwiftUI
import SwiftData

@Model
class AppSettings: Identifiable, Codable {
    @Attribute(.unique) var id: UUID = UUID()
    var theme: String
    var language: String

    init(theme: String, language: String) {
        self.theme = theme
        self.language = language
    }
    
    // Codable conformance
        enum CodingKeys: CodingKey {
            case id, theme, language
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(UUID.self, forKey: .id)
            theme = try container.decode(String.self, forKey: .theme)
            language = try container.decode(String.self, forKey: .language)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(theme, forKey: .theme)
            try container.encode(language, forKey: .language)
        }
}
