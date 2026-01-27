//
//  BlockTreeView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// Renders a hierarchical tree of blocks on the canvas
struct BlockTreeView: View {
    let block: ViewBlock
    let depth: Int

    @Environment(AppStore.self) private var appStore

    private let horizontalSpacing: CGFloat = 40
    private let verticalSpacing: CGFloat = 20
    private let childIndent: CGFloat = 60

    var body: some View {
        VStack(alignment: .leading, spacing: verticalSpacing) {
            // Current block node
            BlockNodeView(block: block)

            // Child blocks
            if !block.sortedChildren.isEmpty {
                HStack(alignment: .top, spacing: 0) {
                    // Connection lines area
                    connectionLinesArea

                    // Children
                    VStack(alignment: .leading, spacing: verticalSpacing) {
                        ForEach(block.sortedChildren) { child in
                            HStack(alignment: .top, spacing: 0) {
                                // Horizontal connector
                                ConnectionLineView(type: .horizontal)
                                    .frame(width: 20, height: 2)
                                    .offset(y: 20)

                                // Child tree
                                BlockTreeView(block: child, depth: depth + 1)
                            }
                        }
                    }
                }
                .padding(.leading, 20)
            }
        }
    }

    // MARK: - Connection Lines

    @ViewBuilder
    private var connectionLinesArea: some View {
        GeometryReader { geometry in
            ConnectionLineView(type: .vertical)
                .frame(width: 2, height: geometry.size.height)
        }
        .frame(width: 2)
    }
}

// MARK: - Preview

#Preview {
    let rootBlock = ViewBlock(id: UUID(), blockType: .vStack, sortOrder: 0)
    let child1 = ViewBlock(id: UUID(), blockType: .text, sortOrder: 0)
    let child2 = ViewBlock(id: UUID(), blockType: .hStack, sortOrder: 1)
    let grandchild1 = ViewBlock(id: UUID(), blockType: .image, sortOrder: 0)
    let grandchild2 = ViewBlock(id: UUID(), blockType: .button, sortOrder: 1)

    child1.parent = rootBlock
    child2.parent = rootBlock
    grandchild1.parent = child2
    grandchild2.parent = child2
    rootBlock.children = [child1, child2]
    child2.children = [grandchild1, grandchild2]

    return ScrollView {
        BlockTreeView(block: rootBlock, depth: 0)
            .padding(40)
    }
    .environment(AppStore())
    .frame(width: 600, height: 400)
}
