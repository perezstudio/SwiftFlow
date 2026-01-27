//
//  PreviewDropZone.swift
//  SwiftFlow
//
//  Created on 1/27/26.
//

import SwiftUI
import SwiftData

/// Overlay that handles drop zones within the device preview
struct PreviewDropZone: View {
    let viewFile: ViewFile
    @Environment(AppStore.self) private var appStore
    @Environment(\.modelContext) private var modelContext

    @State private var isTargeted = false

    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .contentShape(Rectangle())
                .dropDestination(for: BlockDragData.self) { items, location in
                    handleDrop(items: items, at: location, in: geometry)
                } isTargeted: { targeted in
                    isTargeted = targeted
                }
                .overlay {
                    if isTargeted {
                        dropIndicator
                    }
                }
        }
    }

    private var dropIndicator: some View {
        RoundedRectangle(cornerRadius: 8)
            .strokeBorder(Color.accentColor, style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
            .background(Color.accentColor.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(4)
    }

    private func handleDrop(items: [BlockDragData], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        guard let dragData = items.first else { return false }

        // Create new block
        let newBlock = ViewBlock(
            id: UUID(),
            blockType: dragData.blockType,
            sortOrder: 0
        )

        // Insert block into context
        modelContext.insert(newBlock)

        // If no root block exists, set this as root
        if viewFile.rootBlock == nil {
            viewFile.setRootBlock(newBlock)
        } else if let targetBlockId = appStore.drag.dropTarget {
            // Add as child of target block if specified
            // Find target block and add as child
            addToTargetBlock(newBlock, targetId: targetBlockId)
        } else if let rootBlock = viewFile.rootBlock {
            // Add to root block's children
            rootBlock.addChild(newBlock)
        }

        // Select the new block
        appStore.selection.selectBlock(id: newBlock.id)
        _ = appStore.drag.endDrag()

        return true
    }

    private func addToTargetBlock(_ newBlock: ViewBlock, targetId: DragCoordinator.DropTarget) {
        switch targetId {
        case .viewBlockParent(let blockId):
            // Find the target block and add as child
            if let targetBlock = findBlock(withId: blockId, in: viewFile.rootBlock) {
                targetBlock.addChild(newBlock)
            }
        case .viewBlockSibling(let blockId, let insertAfter):
            // Find sibling and insert next to it
            if let siblingBlock = findBlock(withId: blockId, in: viewFile.rootBlock),
               let parent = siblingBlock.parent {
                let index = insertAfter ?
                    parent.sortedChildren.firstIndex(where: { $0.id == blockId })! + 1 :
                    parent.sortedChildren.firstIndex(where: { $0.id == blockId })!
                parent.insertChild(newBlock, at: index)
            }
        default:
            break
        }
    }

    private func findBlock(withId id: UUID, in block: ViewBlock?) -> ViewBlock? {
        guard let block = block else { return nil }

        if block.id == id {
            return block
        }

        for child in block.sortedChildren {
            if let found = findBlock(withId: id, in: child) {
                return found
            }
        }

        return nil
    }
}

/// Empty state drop zone shown when no root block exists
struct EmptyPreviewDropZone: View {
    let viewFile: ViewFile
    @Environment(AppStore.self) private var appStore
    @Environment(\.modelContext) private var modelContext

    @State private var isTargeted = false

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "plus.square.dashed")
                .font(.system(size: 48))
                .foregroundStyle(isTargeted ? Color.accentColor : Color.secondary.opacity(0.3))

            Text("Drop a component here")
                .font(.headline)
                .foregroundStyle(isTargeted ? .primary : .secondary)

            Text("Drag a component from the palette to start building")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    isTargeted ? Color.accentColor : Color.secondary.opacity(0.3),
                    style: StrokeStyle(lineWidth: 2, dash: [8, 4])
                )
                .background(isTargeted ? Color.accentColor.opacity(0.05) : Color.clear)
        )
        .padding(20)
        .dropDestination(for: BlockDragData.self) { items, _ in
            handleDrop(items: items)
        } isTargeted: { targeted in
            isTargeted = targeted
        }
    }

    private func handleDrop(items: [BlockDragData]) -> Bool {
        guard let dragData = items.first else { return false }

        // Create new root block
        let newBlock = ViewBlock(
            id: UUID(),
            blockType: dragData.blockType,
            sortOrder: 0
        )

        modelContext.insert(newBlock)
        viewFile.setRootBlock(newBlock)

        appStore.selection.selectBlock(id: newBlock.id)
        _ = appStore.drag.endDrag()

        return true
    }
}

/// Insert position indicator shown between blocks
struct BlockInsertIndicator: View {
    let position: CGPoint

    var body: some View {
        Rectangle()
            .fill(Color.accentColor)
            .frame(height: 3)
            .clipShape(Capsule())
            .shadow(color: .accentColor.opacity(0.5), radius: 4)
            .position(position)
    }
}

#Preview("Empty Drop Zone") {
    EmptyPreviewDropZone(viewFile: ViewFile(name: "Preview"))
        .environment(AppStore())
        .frame(width: 300, height: 400)
        .padding()
}
