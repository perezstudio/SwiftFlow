//
//  FilesModel.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 6/29/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class Files {
    @Attribute(.unique) var id = UUID()
    var name: String
    var content: String
    var type: String // e.g., "View", "Component", "Model"
    @Relationship var components: [Component]
    
    init(name: String, content: String, type: String, components: [Component] = []) {
        self.name = name
        self.content = content
        self.type = type
        self.components = components
    }

    // Codable conformance
    enum CodingKeys: CodingKey {
        case id, name, content, type
    }
}
