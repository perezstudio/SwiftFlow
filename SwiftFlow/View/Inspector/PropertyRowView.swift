//
//  PropertyRowView.swift
//  SwiftFlow
//
//  Created on 1/27/26.
//

import SwiftUI

/// A single row displaying a view property in the property list
struct PropertyRowView: View {
    let property: ViewProperty
    let isSelected: Bool
    let onSelect: () -> Void
    let onDelete: () -> Void

    @State private var isHovering = false

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 8) {
                // Property wrapper badge
                wrapperBadge

                // Property info
                VStack(alignment: .leading, spacing: 2) {
                    Text(property.name)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.primary)

                    Text(property.typeDefinition.displayName)
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                // Delete button (shown on hover)
                if isHovering {
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.borderless)
                    .help("Delete Property")
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovering = hovering
        }
    }

    private var wrapperBadge: some View {
        Text(property.propertyWrapper.displayName)
            .font(.system(size: 9, weight: .medium, design: .monospaced))
            .foregroundStyle(wrapperColor)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(wrapperColor.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    private var wrapperColor: Color {
        switch property.propertyWrapper.category {
        case .stateManagement:
            return .blue
        case .observation:
            return .purple
        case .swiftData:
            return .orange
        case .environment:
            return .green
        case .focus:
            return .cyan
        case .storage:
            return .yellow
        case .gesture:
            return .pink
        case .animation:
            return .mint
        case .plain:
            return .gray
        }
    }

    private var backgroundColor: Color {
        if isSelected {
            return Color.accentColor.opacity(0.2)
        } else if isHovering {
            return Color(nsColor: .controlBackgroundColor)
        } else {
            return Color.clear
        }
    }
}

#Preview {
    VStack(spacing: 4) {
        PropertyRowView(
            property: .state(name: "count", type: .int, defaultValue: "0"),
            isSelected: false,
            onSelect: {},
            onDelete: {}
        )

        PropertyRowView(
            property: .binding(name: "isPresented", type: .bool),
            isSelected: true,
            onSelect: {},
            onDelete: {}
        )

        PropertyRowView(
            property: .environment(name: "colorScheme", keyPath: "colorScheme", type: .custom("ColorScheme")),
            isSelected: false,
            onSelect: {},
            onDelete: {}
        )
    }
    .padding()
    .frame(width: 280)
}
