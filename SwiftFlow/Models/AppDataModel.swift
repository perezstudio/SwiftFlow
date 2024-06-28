//
//  AppDataModel.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 5/28/24.
//

import SwiftUI
import SwiftData

@Model
class AppData {
    @Attribute(.unique) var id: UUID = UUID()
        var key: String
        var value: String

        init(key: String, value: String) {
            self.key = key
            self.value = value
        }
        
        // Codable conformance
        enum CodingKeys: CodingKey {
            case id, key, value
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(UUID.self, forKey: .id)
            key = try container.decode(String.self, forKey: .key)
            value = try container.decode(String.self, forKey: .value)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(key, forKey: .key)
            try container.encode(value, forKey: .value)
        }
}
