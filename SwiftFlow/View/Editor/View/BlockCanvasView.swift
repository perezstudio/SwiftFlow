//
//  BlockCanvasView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// Zoomable and pannable canvas for displaying the block tree
struct BlockCanvasView: View {
    let viewFile: ViewFile

    @Environment(AppStore.self) private var appStore
    @State private var dragOffset: CGSize = .zero

    var body: some View {
        GeometryReader { geometry in
            ScrollView([.horizontal, .vertical], showsIndicators: true) {
                ZStack(alignment: .topLeading) {
                    // Canvas content area (larger than viewport for panning)
                    Color.clear
                        .frame(
                            width: max(geometry.size.width * 2, 2000),
                            height: max(geometry.size.height * 2, 1500)
                        )

                    // Block tree visualization
                    blockTreeContent
                        .scaleEffect(appStore.editor.zoomLevel)
                        .offset(x: appStore.editor.canvasOffset.x, y: appStore.editor.canvasOffset.y)
                        .offset(dragOffset)
                }
            }
            .gesture(panGesture)
            .gesture(magnificationGesture)
            .dropDestination(for: BlockDragData.self) { items, location in
                handleDrop(items: items, at: location)
            }
        }
    }

    // MARK: - Block Tree Content

    @ViewBuilder
    private var blockTreeContent: some View {
        if let rootBlock = viewFile.rootBlock {
            VStack(alignment: .leading, spacing: 0) {
                BlockTreeView(block: rootBlock, depth: 0)
            }
            .padding(40)
        } else {
            emptyTreeState
        }
    }

    private var emptyTreeState: some View {
        VStack(spacing: 16) {
            Image(systemName: "plus.square.dashed")
                .font(.system(size: 48))
                .foregroundStyle(.tertiary)

            Text("Drop a block here to start")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("Drag a block from the palette")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .frame(width: 200, height: 150)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
                .foregroundStyle(.tertiary)
        )
        .padding(100)
    }

    // MARK: - Gestures

    private var panGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation
            }
            .onEnded { value in
                appStore.editor.canvasOffset.x += value.translation.width
                appStore.editor.canvasOffset.y += value.translation.height
                dragOffset = .zero
            }
    }

    private var magnificationGesture: some Gesture {
        MagnifyGesture()
            .onChanged { value in
                let newZoom = appStore.editor.zoomLevel * value.magnification
                appStore.editor.zoomLevel = min(max(newZoom, 0.25), 4.0)
            }
    }

    // MARK: - Drop Handling

    private func handleDrop(items: [BlockDragData], at location: CGPoint) -> Bool {
        guard let dragData = items.first else { return false }

        // Create new block from drag data
        let newBlock = ViewBlock(
            id: UUID(),
            blockType: dragData.blockType,
            sortOrder: 0
        )

        // If no root block, set as root
        if viewFile.rootBlock == nil {
            viewFile.setRootBlock(newBlock)
        } else if let targetBlockId = appStore.drag.dropTarget {
            // Add as child of target block
            // This would need proper implementation with model context
        }

        appStore.drag.endDrag()
        return true
    }
}

#Preview {
    BlockCanvasView(viewFile: ViewFile(name: "Preview"))
        .environment(AppStore())
        .frame(width: 600, height: 400)
}
