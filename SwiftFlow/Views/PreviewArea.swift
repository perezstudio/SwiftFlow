//
//  PreviewArea.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 7/5/24.
//

import SwiftUI
import UniformTypeIdentifiers
import SwiftData


struct PreviewArea: View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    @Binding var selectedDeviceFrame: DeviceFrame
    @Binding var isDarkMode: Bool
    @Binding var file: Files
    @Binding var draggedComponent: Component?

    var body: some View {
        ZStack {
            Color(isDarkMode ? .black : .white)
                .ignoresSafeArea()
            renderComponents(file.components)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(isDarkMode ? Color.black : Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        .onDrop(of: [UTType.text], delegate: DropViewDelegate(target: $file, draggedComponent: $draggedComponent, modelContext: modelContext))
    }

    @ViewBuilder
    private func renderComponents(_ components: [Component]) -> some View {
        ForEach(components) { component in
            renderComponent(component)
        }
    }

    @ViewBuilder
    private func renderComponent(_ component: Component) -> some View {
        switch component.type {
        case .text:
            Text(component.content)
        case .vStack:
            VStack {
                renderComponents(component.children)
            }
        case .hStack:
            HStack {
                renderComponents(component.children)
            }
        case .list:
            List {
                renderComponents(component.children)
            }
        case .picker:
            Picker(component.config.label ?? component.content, selection: .constant(1)) {
                renderComponents(component.children)
            }
        case .unknown:
            EmptyView()
        case .image:
            EmptyView()
        }
    }
}

struct DropViewDelegate: DropDelegate {
    @Binding var target: Files
    @Binding var draggedComponent: Component?
    let modelContext: ModelContext

    func performDrop(info: DropInfo) -> Bool {
        guard let draggedComponent = draggedComponent else { return false }
        
        // Decide where to add the component based on target component type
        if let targetComponent = target.components.first(where: { $0.type == .vStack || $0.type == .hStack || $0.type == .list || $0.type == .picker }) {
            targetComponent.children.append(draggedComponent)
        } else {
            target.components.append(draggedComponent)
        }
        
        modelContext.insert(draggedComponent)
        self.draggedComponent = nil
        return true
    }
}

private func optionalBinding<T>(_ binding: Binding<T?>) -> Binding<T>? {
    guard let value = binding.wrappedValue else {
        return nil
    }
    return Binding(
        get: { value },
        set: { newValue in
            binding.wrappedValue = newValue
        }
    )
}

