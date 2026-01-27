//
//  ModifierRowView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// Single row displaying a modifier in the list
struct ModifierRowView: View {
    let modifier: ViewModifier
    let isSelected: Bool
    let onSelect: () -> Void
    let onDelete: () -> Void

    @State private var isHovering = false

    var body: some View {
        HStack(spacing: 8) {
            // Drag handle
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 10))
                .foregroundStyle(.tertiary)
                .opacity(isHovering ? 1 : 0)

            // Modifier icon
            Image(systemName: modifier.modifierType.iconName)
                .font(.system(size: 12))
                .foregroundStyle(modifier.modifierType.category.color)
                .frame(width: 20)

            // Modifier info
            VStack(alignment: .leading, spacing: 1) {
                Text(modifier.modifierType.displayName)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.primary)

                if let summary = modifierSummary {
                    Text(summary)
                        .font(.system(size: 9))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            // Toggle enabled
            if isHovering || isSelected {
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 10))
                        .foregroundStyle(.red.opacity(0.8))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
        .contentShape(Rectangle())
        .onHover { hovering in
            isHovering = hovering
        }
        .onTapGesture {
            onSelect()
        }
    }

    // MARK: - Modifier Summary

    private var modifierSummary: String? {
        switch modifier.modifierType {
        case .padding:
            if let value: Int = modifier.getParam("value") {
                return "\(value)pt"
            }
            if let edges: String = modifier.getParam("edges") {
                return edges
            }
        case .frame:
            var parts: [String] = []
            if let width: Int = modifier.getParam("width") {
                parts.append("w: \(width)")
            }
            if let height: Int = modifier.getParam("height") {
                parts.append("h: \(height)")
            }
            return parts.isEmpty ? nil : parts.joined(separator: ", ")
        case .foregroundStyle:
            return modifier.getParam("color")
        case .background:
            return modifier.getParam("color")
        case .font:
            return modifier.getParam("style")
        case .cornerRadius:
            if let radius: Int = modifier.getParam("radius") {
                return "\(radius)pt"
            }
        case .opacity:
            if let value: Double = modifier.getParam("value") {
                return String(format: "%.0f%%", value * 100)
            }
        case .shadow:
            if let radius: Int = modifier.getParam("radius") {
                return "radius: \(radius)"
            }
        default:
            break
        }
        return nil
    }
}

#Preview {
    VStack(spacing: 0) {
        ModifierRowView(
            modifier: ViewModifier(modifierType: .padding, sortOrder: 0),
            isSelected: false,
            onSelect: { },
            onDelete: { }
        )
        Divider()
        ModifierRowView(
            modifier: ViewModifier(modifierType: .foregroundStyle, sortOrder: 1),
            isSelected: true,
            onSelect: { },
            onDelete: { }
        )
    }
    .frame(width: 280)
}
