//
//  ViewComponentModel.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 5/28/24.
//

import SwiftUI
import SwiftData

@Model
class ViewComponent: Identifiable, Codable {
    @Attribute(.unique) var id: UUID = UUID()
    var type: String
    var properties: [String: String]
    @Relationship var children: [ViewComponent] = []

    init(type: String, properties: [String: String] = [:], children: [ViewComponent] = []) {
        self.type = type
        self.properties = properties
        self.children = children
    }
    
    // Codable conformance
    enum CodingKeys: CodingKey {
        case id, type, properties, children
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        type = try container.decode(String.self, forKey: .type)
        properties = try container.decode([String: String].self, forKey: .properties)
        children = try container.decode([ViewComponent].self, forKey: .children)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(properties, forKey: .properties)
        try container.encode(children, forKey: .children)
    }
}
