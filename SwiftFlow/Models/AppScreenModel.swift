//
//  AppScreenModel.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 5/28/24.
//

import SwiftUI
import SwiftData

@Model
class AppScreen: Identifiable, Codable {
    @Attribute(.unique) var id: UUID = UUID()
    var title: String
    @Relationship var rootComponent: ViewComponent?

    init(title: String, rootComponent: ViewComponent? = nil) {
        self.title = title
        self.rootComponent = rootComponent
    }
    
    // Codable conformance
    enum CodingKeys: CodingKey {
        case id, title, rootComponent
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        rootComponent = try container.decodeIfPresent(ViewComponent.self, forKey: .rootComponent)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(rootComponent, forKey: .rootComponent)
    }
}
