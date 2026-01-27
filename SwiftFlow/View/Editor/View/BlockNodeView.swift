//
//  BlockNodeView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// Visual representation of a single block on the canvas
struct BlockNodeView: View {
    let block: ViewBlock

    @Environment(AppStore.self) private var appStore
    @State private var isHovering = false
    @State private var isDragTarget = false

    private var isSelected: Bool {
        appStore.selectedBlockId == block.id
    }

    var body: some View {
        HStack(spacing: 8) {
            // Block type icon
            Image(systemName: block.blockType.iconName)
                .font(.system(size: 14))
                .foregroundStyle(block.blockType.category.color)
                .frame(width: 24, height: 24)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(block.blockType.category.color.opacity(0.15))
                )

            // Block info
            VStack(alignment: .leading, spacing: 2) {
                // Block name/type
                Text(block.displayName)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.primary)

                // Subtitle (configuration hint)
                if let subtitle = blockSubtitle {
                    Text(subtitle)
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer(minLength: 8)

            // Indicators
            HStack(spacing: 4) {
                // Has modifiers indicator
                if block.hasModifiers {
                    Image(systemName: "paintbrush")
                        .font(.system(size: 10))
                        .foregroundStyle(.orange)
                }

                // Has children indicator
                if block.hasChildren {
                    Text("\(block.sortedChildren.count)")
                        .font(.system(size: 9, weight: .medium, design: .monospaced))
                        .foregroundStyle(.tertiary)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(Color(nsColor: .separatorColor).opacity(0.5))
                        )
                }
            }

            // Action menu
            Menu {
                Button("Add Child Block") {
                    // Add child action
                }

                Button("Add Modifier") {
                    // Add modifier action
                }

                Divider()

                Button("Duplicate") {
                    // Duplicate action
                }

                Button("Delete", role: .destructive) {
                    // Delete action
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .frame(width: 20, height: 20)
            }
            .menuStyle(.borderlessButton)
            .menuIndicator(.hidden)
            .opacity(isHovering || isSelected ? 1 : 0)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(minWidth: 180)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(backgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(borderColor, lineWidth: isSelected ? 2 : 1)
        )
        .shadow(color: shadowColor, radius: isSelected ? 4 : 1, y: isSelected ? 2 : 1)
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
        .onHover { hovering in
            isHovering = hovering
        }
        .onTapGesture {
            appStore.selection.selectBlock(id: block.id)
        }
        .dropDestination(for: BlockDragData.self) { items, location in
            handleChildDrop(items: items)
        } isTargeted: { targeted in
            isDragTarget = targeted
            if targeted {
                appStore.drag.setDropTarget(.viewBlockParent(block.id), isValid: true)
            } else {
                appStore.drag.setDropTarget(nil, isValid: false)
            }
        }
        .contextMenu {
            Button("Cut") { }
            Button("Copy") { }
            Button("Paste") { }
            Divider()
            Button("Delete", role: .destructive) { }
        }
    }

    // MARK: - Styling

    private var backgroundColor: Color {
        if isDragTarget {
            return block.blockType.category.color.opacity(0.1)
        } else if isSelected {
            return Color(nsColor: .controlBackgroundColor)
        } else {
            return Color(nsColor: .textBackgroundColor)
        }
    }

    private var borderColor: Color {
        if isDragTarget {
            return block.blockType.category.color
        } else if isSelected {
            return .accentColor
        } else {
            return Color(nsColor: .separatorColor)
        }
    }

    private var shadowColor: Color {
        if isSelected {
            return .accentColor.opacity(0.3)
        } else {
            return .black.opacity(0.05)
        }
    }

    // MARK: - Subtitle

    private var blockSubtitle: String? {
        // Show configuration hints based on block type
        switch block.blockType {
        case .text:
            return block.textContent ?? "\"Hello\""
        case .image:
            return block.getConfig("systemName", default: "photo")
        case .button:
            return block.buttonLabel ?? "Button"
        case .vStack, .hStack, .zStack:
            let alignment: String = block.getConfig("alignment", default: "center")
            let spacing: Int = block.getConfig("spacing", default: 8)
            return "alignment: .\(alignment), spacing: \(spacing)"
        case .spacer:
            if let minLength: Int = block.getConfig("minLength") {
                return "minLength: \(minLength)"
            }
            return nil
        default:
            return nil
        }
    }

    // MARK: - Drop Handling

    private func handleChildDrop(items: [BlockDragData]) -> Bool {
        guard let dragData = items.first else { return false }

        // Create new block as child
        let newBlock = ViewBlock(
            id: UUID(),
            blockType: dragData.blockType,
            sortOrder: block.sortedChildren.count
        )
        newBlock.parent = block

        var children = block.children ?? []
        children.append(newBlock)
        block.children = children

        appStore.drag.endDrag()
        return true
    }
}

// MARK: - ViewBlock Extension

extension ViewBlock {
    var hasModifiers: Bool {
        !(modifiers ?? []).isEmpty
    }
}

#Preview {
    VStack(spacing: 20) {
        BlockNodeView(block: ViewBlock(id: UUID(), blockType: .vStack, sortOrder: 0))
        BlockNodeView(block: ViewBlock(id: UUID(), blockType: .text, sortOrder: 0))
        BlockNodeView(block: ViewBlock(id: UUID(), blockType: .button, sortOrder: 0))
    }
    .padding(40)
    .environment(AppStore())
}
