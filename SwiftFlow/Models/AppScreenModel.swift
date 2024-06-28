//
//  AppScreenModel.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 5/28/24.
//

import SwiftUI
import SwiftData

@Model
class AppScreen {
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
}
