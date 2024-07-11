//
//  ComponentModel.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 7/5/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Component {
    var id: UUID = UUID()
    var type: ComponentType
    var content: String
    var config: ComponentConfig
    @Relationship var children: [Component]

    init(type: ComponentType, content: String = "", config: ComponentConfig = ComponentConfig(), children: [Component] = []) {
        self.type = type
        self.content = content
        self.config = config
        self.children = children
    }
}

enum ComponentType: String, Codable, CaseIterable {
    case text, vStack, hStack, list, picker, image, unknown

    var icon: Image {
        switch self {
        case .text:
            return Image(systemName: "textformat")
        case .vStack:
            return Image(systemName: "square.stack.3d.up")
        case .hStack:
            return Image(systemName: "square.split.2x1")
        case .list:
            return Image(systemName: "list.bullet")
        case .picker:
            return Image(systemName: "arrowtriangle.down.circle")
        case .image:
            return Image(systemName: "photo")
        case .unknown:
            return Image(systemName: "questionmark")
        }
    }
    
    var displayName: String {
        switch self {
        case .text:
            return "Text"
        case .vStack:
            return "Vertical Stack"
        case .hStack:
            return "Horizontal Stack"
        case .list:
            return "List"
        case .picker:
            return "Picker"
        case .image:
            return "Image"
        case .unknown:
            return "Unknown"
        }
    }
    
    var description: String {
        switch self {
        case .text:
            return "A text component for displaying text."
        case .vStack:
            return "A vertical stack component for arranging views vertically."
        case .hStack:
            return "A horizontal stack component for arranging views horizontally."
        case .list:
            return "A list component for displaying a collection of items."
        case .picker:
            return "A picker component for selecting from a list of options."
        case .image:
            return "An image component for displaying images."
        case .unknown:
            return "An unknown component type."
        }
    }
}

struct ComponentConfig: Codable {
    var label: String?
    var style: String?
    var function: String?
    var additionalFields: [String: String]?

    init(label: String? = nil, style: String? = nil, function: String? = nil, additionalFields: [String: String]? = nil) {
        self.label = label
        self.style = style
        self.function = function
        self.additionalFields = additionalFields
    }
}

struct PrefilledComponents {
    static let textComponent = Component(type: .text, content: "Sample Text", config: ComponentConfig(label: "Text Label"))
    static let vStackComponent = Component(type: .vStack, config: ComponentConfig(label: "Vertical Stack"))
    static let hStackComponent = Component(type: .hStack, config: ComponentConfig(label: "Horizontal Stack"))
    static let listComponent = Component(type: .list, config: ComponentConfig(label: "List Label"))
    static let pickerComponent = Component(type: .picker, config: ComponentConfig(label: "Picker Label"))
    
    static let allComponents: [Component] = [
        textComponent,
        vStackComponent,
        hStackComponent,
        listComponent,
        pickerComponent
    ]
}
