//
//  BlockInspectorView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// Inspector for a selected view block
struct BlockInspectorView: View {
    @Bindable var block: ViewBlock
    @Environment(\.modelContext) private var modelContext

    @State private var isConfigExpanded = true
    @State private var isModifiersExpanded = true

    var body: some View {
        VStack(spacing: 0) {
            // Block type header
            blockTypeHeader

            Divider()
                .padding(.vertical, 4)

            // Configuration section
            CollapsibleSection("Configuration", isExpanded: $isConfigExpanded) {
                BlockConfigurationEditor(block: block)
            }

            Divider()
                .padding(.vertical, 4)

            // Modifiers section
            CollapsibleSection(
                isExpanded: $isModifiersExpanded,
                header: {
                    HStack {
                        Text("Modifiers")
                            .font(.headline)

                        Spacer()

                        Text("\(block.sortedModifiers.count)")
                            .font(.system(size: 10))
                            .foregroundStyle(.tertiary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(Color(nsColor: .separatorColor).opacity(0.5)))

                        AddModifierMenu(block: block)
                    }
                },
                content: {
                    ModifierListEditor(block: block)
                }
            )
        }
        .padding(.vertical, 8)
    }

    // MARK: - Block Type Header

    private var blockTypeHeader: some View {
        HStack(spacing: 10) {
            // Block type icon
            Image(systemName: block.blockType.iconName)
                .font(.system(size: 20))
                .foregroundStyle(block.blockType.category.color)
                .frame(width: 36, height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(block.blockType.category.color.opacity(0.1))
                )

            // Block info
            VStack(alignment: .leading, spacing: 2) {
                Text(block.blockType.displayName)
                    .font(.system(size: 13, weight: .semibold))

                Text(block.blockType.category.displayName)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}

// MARK: - Preview

#Preview {
    let block = ViewBlock(blockType: .vStack)
    return BlockInspectorView(block: block)
        .frame(width: 280, height: 500)
}
