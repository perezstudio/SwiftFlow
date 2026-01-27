//
//  TreeNode.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// A styled tree node row with expand/collapse, icon, and selection
struct TreeNodeView: View {
    let title: String
    let systemImage: String
    let depth: Int
    let hasChildren: Bool
    let isExpanded: Bool
    let isSelected: Bool
    let onToggleExpand: () -> Void
    let onSelect: () -> Void

    private let indentWidth: CGFloat = 16
    private let disclosureWidth: CGFloat = 16

    init(
        title: String,
        systemImage: String,
        depth: Int = 0,
        hasChildren: Bool = false,
        isExpanded: Bool = false,
        isSelected: Bool = false,
        onToggleExpand: @escaping () -> Void = {},
        onSelect: @escaping () -> Void = {}
    ) {
        self.title = title
        self.systemImage = systemImage
        self.depth = depth
        self.hasChildren = hasChildren
        self.isExpanded = isExpanded
        self.isSelected = isSelected
        self.onToggleExpand = onToggleExpand
        self.onSelect = onSelect
    }

    var body: some View {
        HStack(spacing: 4) {
            // Indentation based on depth
            if depth > 0 {
                Color.clear
                    .frame(width: CGFloat(depth) * indentWidth)
            }

            // Disclosure triangle
            if hasChildren {
                Button(action: onToggleExpand) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(.tertiary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .animation(.easeInOut(duration: 0.15), value: isExpanded)
                }
                .buttonStyle(.plain)
                .frame(width: disclosureWidth, height: disclosureWidth)
            } else {
                Color.clear
                    .frame(width: disclosureWidth)
            }

            // Icon
            Image(systemName: systemImage)
                .font(.system(size: 12))
                .foregroundStyle(isSelected ? .primary : .secondary)
                .frame(width: 16)

            // Title
            Text(title)
                .font(.system(size: 12))
                .foregroundStyle(isSelected ? .primary : .primary)
                .lineLimit(1)

            Spacer()
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
        .contentShape(Rectangle())
        .onTapGesture(perform: onSelect)
    }
}

/// A tree node with badge indicator
struct TreeNodeWithBadge: View {
    let title: String
    let systemImage: String
    let badge: String?
    let badgeColor: Color
    let depth: Int
    let hasChildren: Bool
    let isExpanded: Bool
    let isSelected: Bool
    let onToggleExpand: () -> Void
    let onSelect: () -> Void

    private let indentWidth: CGFloat = 16

    init(
        title: String,
        systemImage: String,
        badge: String? = nil,
        badgeColor: Color = .secondary,
        depth: Int = 0,
        hasChildren: Bool = false,
        isExpanded: Bool = false,
        isSelected: Bool = false,
        onToggleExpand: @escaping () -> Void = {},
        onSelect: @escaping () -> Void = {}
    ) {
        self.title = title
        self.systemImage = systemImage
        self.badge = badge
        self.badgeColor = badgeColor
        self.depth = depth
        self.hasChildren = hasChildren
        self.isExpanded = isExpanded
        self.isSelected = isSelected
        self.onToggleExpand = onToggleExpand
        self.onSelect = onSelect
    }

    var body: some View {
        HStack(spacing: 4) {
            if depth > 0 {
                Color.clear.frame(width: CGFloat(depth) * indentWidth)
            }

            if hasChildren {
                Button(action: onToggleExpand) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(.tertiary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .buttonStyle(.plain)
                .frame(width: 16)
            } else {
                Color.clear.frame(width: 16)
            }

            Image(systemName: systemImage)
                .font(.system(size: 12))
                .foregroundStyle(isSelected ? .primary : .secondary)

            Text(title)
                .font(.system(size: 12))
                .lineLimit(1)

            Spacer()

            if let badge {
                Text(badge)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(badgeColor)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(badgeColor.opacity(0.15))
                    .clipShape(Capsule())
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
        .contentShape(Rectangle())
        .onTapGesture(perform: onSelect)
    }
}

#Preview {
    VStack(spacing: 0) {
        TreeNodeView(
            title: "VStack",
            systemImage: "square.stack",
            depth: 0,
            hasChildren: true,
            isExpanded: true,
            isSelected: false,
            onToggleExpand: {},
            onSelect: {}
        )

        TreeNodeView(
            title: "Text",
            systemImage: "text.quote",
            depth: 1,
            hasChildren: false,
            isSelected: true,
            onSelect: {}
        )

        TreeNodeView(
            title: "HStack",
            systemImage: "square.split.1x2",
            depth: 1,
            hasChildren: true,
            isExpanded: false,
            onToggleExpand: {},
            onSelect: {}
        )

        Divider()
            .padding(.vertical, 8)

        TreeNodeWithBadge(
            title: "ContentView",
            systemImage: "doc",
            badge: "Entry",
            badgeColor: .green,
            depth: 0,
            hasChildren: false,
            isSelected: false,
            onSelect: {}
        )

        TreeNodeWithBadge(
            title: "DetailView",
            systemImage: "doc",
            depth: 0,
            hasChildren: false,
            isSelected: false,
            onSelect: {}
        )
    }
    .frame(width: 250)
    .padding(.vertical, 8)
}
