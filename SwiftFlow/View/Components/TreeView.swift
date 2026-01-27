//
//  TreeView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// Protocol for tree data that can be displayed in TreeView
protocol TreeNodeData: Identifiable where ID == UUID {
    var children: [Self] { get }
    var hasChildren: Bool { get }
}

extension TreeNodeData {
    var hasChildren: Bool {
        !children.isEmpty
    }
}

/// A generic tree view that displays hierarchical data
struct TreeView<Data: TreeNodeData, Content: View>: View {
    let data: [Data]
    @Binding var expandedNodes: Set<UUID>
    @Binding var selectedNode: UUID?
    let content: (Data, Int, Bool) -> Content

    init(
        _ data: [Data],
        expandedNodes: Binding<Set<UUID>>,
        selectedNode: Binding<UUID?>,
        @ViewBuilder content: @escaping (Data, Int, Bool) -> Content
    ) {
        self.data = data
        self._expandedNodes = expandedNodes
        self._selectedNode = selectedNode
        self.content = content
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(data) { node in
                    TreeNodeRow(
                        node: node,
                        depth: 0,
                        expandedNodes: $expandedNodes,
                        selectedNode: $selectedNode,
                        content: content
                    )
                }
            }
        }
    }
}

/// Internal view for rendering a single tree node row
private struct TreeNodeRow<Data: TreeNodeData, Content: View>: View {
    let node: Data
    let depth: Int
    @Binding var expandedNodes: Set<UUID>
    @Binding var selectedNode: UUID?
    let content: (Data, Int, Bool) -> Content

    private var isExpanded: Bool {
        expandedNodes.contains(node.id)
    }

    private var isSelected: Bool {
        selectedNode == node.id
    }

    var body: some View {
        VStack(spacing: 0) {
            // Node content
            content(node, depth, isSelected)
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedNode = node.id
                }

            // Children (if expanded)
            if isExpanded && node.hasChildren {
                ForEach(node.children) { child in
                    TreeNodeRow(
                        node: child,
                        depth: depth + 1,
                        expandedNodes: $expandedNodes,
                        selectedNode: $selectedNode,
                        content: content
                    )
                }
            }
        }
    }
}

/// A standalone tree view with built-in expand/collapse handling
struct ManagedTreeView<Data: TreeNodeData, Content: View>: View {
    let data: [Data]
    @Binding var selectedNode: UUID?
    let content: (Data, Int, Bool, Bool, @escaping () -> Void) -> Content
    @State private var expandedNodes: Set<UUID> = []

    init(
        _ data: [Data],
        selectedNode: Binding<UUID?>,
        initiallyExpanded: Bool = true,
        @ViewBuilder content: @escaping (Data, Int, Bool, Bool, @escaping () -> Void) -> Content
    ) {
        self.data = data
        self._selectedNode = selectedNode
        self.content = content

        if initiallyExpanded {
            // Expand all nodes initially
            var expanded = Set<UUID>()
            func collectIds(_ nodes: [Data]) {
                for node in nodes {
                    expanded.insert(node.id)
                    collectIds(node.children)
                }
            }
            collectIds(data)
            self._expandedNodes = State(initialValue: expanded)
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(data) { node in
                    ManagedTreeNodeRow(
                        node: node,
                        depth: 0,
                        expandedNodes: $expandedNodes,
                        selectedNode: $selectedNode,
                        content: content
                    )
                }
            }
        }
    }
}

private struct ManagedTreeNodeRow<Data: TreeNodeData, Content: View>: View {
    let node: Data
    let depth: Int
    @Binding var expandedNodes: Set<UUID>
    @Binding var selectedNode: UUID?
    let content: (Data, Int, Bool, Bool, @escaping () -> Void) -> Content

    private var isExpanded: Bool {
        expandedNodes.contains(node.id)
    }

    private var isSelected: Bool {
        selectedNode == node.id
    }

    private func toggleExpanded() {
        if isExpanded {
            expandedNodes.remove(node.id)
        } else {
            expandedNodes.insert(node.id)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            content(node, depth, isSelected, isExpanded, toggleExpanded)
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedNode = node.id
                }

            if isExpanded && node.hasChildren {
                ForEach(node.children) { child in
                    ManagedTreeNodeRow(
                        node: child,
                        depth: depth + 1,
                        expandedNodes: $expandedNodes,
                        selectedNode: $selectedNode,
                        content: content
                    )
                }
            }
        }
    }
}

// MARK: - Preview

private struct SampleNode: TreeNodeData {
    let id = UUID()
    let name: String
    let icon: String
    var children: [SampleNode] = []
}

#Preview {
    let sampleData = [
        SampleNode(name: "VStack", icon: "square.stack", children: [
            SampleNode(name: "Text", icon: "text.quote"),
            SampleNode(name: "HStack", icon: "square.split.1x2", children: [
                SampleNode(name: "Image", icon: "photo"),
                SampleNode(name: "Button", icon: "button.horizontal")
            ]),
            SampleNode(name: "Spacer", icon: "arrow.up.and.down")
        ])
    ]

    return ManagedTreeView(sampleData, selectedNode: .constant(nil)) { node, depth, isSelected, isExpanded, toggle in
        HStack(spacing: 4) {
            // Indentation
            ForEach(0..<depth, id: \.self) { _ in
                Color.clear.frame(width: 16)
            }

            // Disclosure indicator
            if node.hasChildren {
                Button(action: toggle) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10))
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .frame(width: 16)
            } else {
                Color.clear.frame(width: 16)
            }

            // Icon and name
            Image(systemName: node.icon)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)

            Text(node.name)
                .font(.system(size: 12))

            Spacer()
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(isSelected ? Color.accentColor.opacity(0.2) : Color.clear)
    }
    .frame(width: 250, height: 300)
}
