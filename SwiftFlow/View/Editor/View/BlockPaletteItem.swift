//
//  BlockPaletteItem.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI
import UniformTypeIdentifiers

/// Individual block item in the palette that can be dragged to the canvas
struct BlockPaletteItem: View {
    let blockType: ViewBlockType

    @Environment(AppStore.self) private var appStore
    @State private var isDragging = false

    var body: some View {
        VStack(spacing: 4) {
            // Icon
            Image(systemName: blockType.iconName)
                .font(.system(size: 18))
                .foregroundStyle(blockType.category.color)
                .frame(width: 36, height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(blockType.category.color.opacity(0.1))
                )

            // Name
            Text(blockType.displayName)
                .font(.system(size: 9))
                .foregroundStyle(.primary)
                .lineLimit(1)
        }
        .frame(width: 72, height: 60)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(nsColor: .controlBackgroundColor))
                .shadow(color: .black.opacity(isDragging ? 0.2 : 0.05), radius: isDragging ? 4 : 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(isDragging ? blockType.category.color : Color.clear, lineWidth: 1)
        )
        .scaleEffect(isDragging ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: isDragging)
        .draggable(BlockDragData(blockType: blockType)) {
            // Drag preview
            BlockPaletteItemPreview(blockType: blockType)
        }
    }
}

/// Preview shown while dragging a block
struct BlockPaletteItemPreview: View {
    let blockType: ViewBlockType

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: blockType.iconName)
                .font(.system(size: 16))
                .foregroundStyle(blockType.category.color)

            Text(blockType.displayName)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(nsColor: .controlBackgroundColor))
                .shadow(color: .black.opacity(0.2), radius: 4)
        )
    }
}

// MARK: - Block Drag Data

struct BlockDragData: Codable, Transferable {
    let blockType: ViewBlockType

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .swiftFlowBlockDrag)
    }
}

// MARK: - Custom UTType

extension UTType {
    static var swiftFlowBlockDrag: UTType {
        UTType(exportedAs: "com.swiftflow.block-drag")
    }
}

#Preview {
    HStack(spacing: 12) {
        BlockPaletteItem(blockType: .vStack)
        BlockPaletteItem(blockType: .text)
        BlockPaletteItem(blockType: .button)
        BlockPaletteItem(blockType: .image)
    }
    .padding()
    .environment(AppStore())
}
