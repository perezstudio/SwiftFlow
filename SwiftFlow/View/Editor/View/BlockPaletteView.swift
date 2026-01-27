//
//  BlockPaletteView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// Block palette showing available blocks organized by category
struct BlockPaletteView: View {
    @Environment(AppStore.self) private var appStore

    @State private var searchText = ""
    @State private var expandedCategories: Set<ViewBlockCategory> = Set(ViewBlockCategory.allCases)

    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            searchBar

            Divider()

            // Categories and blocks
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(ViewBlockCategory.allCases) { category in
                        if !filteredBlocks(for: category).isEmpty {
                            categorySection(category)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 12))
                .foregroundStyle(.tertiary)

            TextField("Search blocks...", text: $searchText)
                .textFieldStyle(.plain)
                .font(.system(size: 12))

            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(.tertiary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }

    // MARK: - Category Section

    @ViewBuilder
    private func categorySection(_ category: ViewBlockCategory) -> some View {
        let isExpanded = expandedCategories.contains(category)
        let blocks = filteredBlocks(for: category)

        VStack(spacing: 0) {
            // Category header
            Button(action: { toggleCategory(category) }) {
                HStack(spacing: 6) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(.tertiary)
                        .frame(width: 12)

                    Image(systemName: category.iconName)
                        .font(.system(size: 11))
                        .foregroundStyle(category.color)

                    Text(category.displayName)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.primary)

                    Spacer()

                    Text("\(blocks.count)")
                        .font(.system(size: 10))
                        .foregroundStyle(.tertiary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            // Blocks in category
            if isExpanded {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
                    ForEach(blocks, id: \.self) { blockType in
                        BlockPaletteItem(blockType: blockType)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
            }
        }
    }

    // MARK: - Helpers

    private func toggleCategory(_ category: ViewBlockCategory) {
        if expandedCategories.contains(category) {
            expandedCategories.remove(category)
        } else {
            expandedCategories.insert(category)
        }
    }

    private func filteredBlocks(for category: ViewBlockCategory) -> [ViewBlockType] {
        let categoryBlocks = category.blocks

        if searchText.isEmpty {
            return categoryBlocks
        }

        return categoryBlocks.filter { blockType in
            blockType.displayName.localizedCaseInsensitiveContains(searchText)
        }
    }
}

// MARK: - ViewBlockCategory Extension

extension ViewBlockCategory {
    var iconName: String {
        switch self {
        case .layout: return "rectangle.3.group"
        case .spacing: return "arrow.up.and.down.and.arrow.left.and.right"
        case .text: return "textformat"
        case .controls: return "button.vertical.right.press"
        case .media: return "photo"
        case .shapes: return "seal"
        case .controlFlow: return "arrow.triangle.branch"
        case .navigation: return "arrow.triangle.turn.up.right.diamond"
        case .custom: return "puzzlepiece"
        }
    }

    var color: Color {
        switch self {
        case .layout: return .blue
        case .spacing: return .gray
        case .text: return .orange
        case .controls: return .green
        case .media: return .pink
        case .shapes: return .yellow
        case .controlFlow: return .purple
        case .navigation: return .indigo
        case .custom: return .cyan
        }
    }
}

#Preview {
    BlockPaletteView()
        .environment(AppStore())
        .frame(width: 220, height: 500)
}
