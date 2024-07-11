//
//  AddMenuView.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 7/5/24.
//

import SwiftUI

struct AddMenuView: View {
    @Binding var draggedComponent: Component?
    let components: [(type: ComponentType, name: String)] = [
        (.text, "Text"),
        (.vStack, "VStack"),
        (.hStack, "HStack"),
        (.list, "List"),
        (.picker, "Picker")
    ]

    var body: some View {
        List(components, id: \.type) { component in
            HStack {
                component.type.icon
                Text(component.name)
            }
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .onDrag {
                self.draggedComponent = Component(type: component.type, config: ComponentConfig(label: component.name))
                return NSItemProvider(object: component.name as NSString)
            }
        }
    }

    private func component(for component: String) -> Component {
        switch component {
        case "Text":
            return Component(type: .text, content: "New Text")
        case "VStack":
            return Component(type: .vStack)
        case "HStack":
            return Component(type: .hStack)
        case "List":
            return Component(type: .list)
        case "Picker":
            return Component(type: .picker)
        default:
            return Component(type: .unknown)
        }
    }
}

