//
//  ModifierListEditor.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI
import SwiftData

/// Editable list of modifiers applied to a block
struct ModifierListEditor: View {
    @Bindable var block: ViewBlock
    @Environment(\.modelContext) private var modelContext

    @State private var selectedModifierId: UUID?
    @State private var editingModifier: ViewModifier?

    var body: some View {
        VStack(spacing: 0) {
            if block.sortedModifiers.isEmpty {
                emptyState
            } else {
                ForEach(block.sortedModifiers) { modifier in
                    ModifierRowView(
                        modifier: modifier,
                        isSelected: selectedModifierId == modifier.id,
                        onSelect: { selectedModifierId = modifier.id },
                        onDelete: { deleteModifier(modifier) }
                    )

                    if modifier.id != block.sortedModifiers.last?.id {
                        Divider()
                            .padding(.leading, 32)
                    }
                }
            }

            // Modifier configuration when selected
            if let modifierId = selectedModifierId,
               let modifier = block.sortedModifiers.first(where: { $0.id == modifierId }) {
                Divider()
                    .padding(.vertical, 8)

                ModifierConfigEditor(modifier: modifier)
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "paintbrush")
                .font(.system(size: 20))
                .foregroundStyle(.tertiary)

            Text("No modifiers")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text("Add modifiers to style this view")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }

    // MARK: - Actions

    private func deleteModifier(_ modifier: ViewModifier) {
        if selectedModifierId == modifier.id {
            selectedModifierId = nil
        }

        block.modifiers?.removeAll { $0.id == modifier.id }
        modelContext.delete(modifier)
        try? modelContext.save()
    }
}

#Preview {
    ModifierListEditor(block: ViewBlock(blockType: .text))
        .frame(width: 280)
}
