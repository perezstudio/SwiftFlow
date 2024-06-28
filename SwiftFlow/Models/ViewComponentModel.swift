//
//  ViewComponentModel.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 5/28/24.
//

import SwiftUI
import SwiftData

@Model
class ViewComponent {
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
}
