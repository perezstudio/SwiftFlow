//
//  AssetsLibraryView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI
import SwiftData

/// Asset browser showing colors, images, and other assets
struct AssetsLibraryView: View {
    @Environment(AppStore.self) private var appStore
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Asset.name) private var assets: [Asset]

    @State private var searchText = ""
    @State private var selectedCategory: AssetType? = nil
    @State private var showingAddAssetSheet = false

    var body: some View {
        VStack(spacing: 0) {
            // Search and filter bar
            searchBar

            Divider()

            // Category filter
            categoryFilter

            Divider()

            // Assets list
            assetsList
        }
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 12))
                .foregroundStyle(.tertiary)

            TextField("Search assets...", text: $searchText)
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

            Button(action: { showingAddAssetSheet = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }

    // MARK: - Category Filter

    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                categoryChip(nil, label: "All")

                ForEach(AssetType.allCases) { assetType in
                    categoryChip(assetType, label: assetType.displayName)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
        }
    }

    @ViewBuilder
    private func categoryChip(_ category: AssetType?, label: String) -> some View {
        let isSelected = selectedCategory == category

        Button(action: { selectedCategory = category }) {
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(isSelected ? .white : .secondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(isSelected ? Color.accentColor : Color(nsColor: .controlBackgroundColor))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Assets List

    private var assetsList: some View {
        ScrollView {
            LazyVStack(spacing: 2) {
                if filteredAssets.isEmpty {
                    emptyState
                } else {
                    ForEach(filteredAssets) { asset in
                        assetRow(asset)
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 32))
                .foregroundStyle(.tertiary)

            Text("No Assets")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button("Add Asset") {
                showingAddAssetSheet = true
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }

    @ViewBuilder
    private func assetRow(_ asset: Asset) -> some View {
        HStack(spacing: 10) {
            // Asset preview
            assetPreview(asset)
                .frame(width: 32, height: 32)
                .clipShape(RoundedRectangle(cornerRadius: 4))

            VStack(alignment: .leading, spacing: 2) {
                Text(asset.name)
                    .font(.system(size: 12))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text(asset.assetType.displayName)
                    .font(.system(size: 10))
                    .foregroundStyle(.tertiary)
            }

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .contextMenu {
            Button("Copy Reference") {
                // Copy asset reference
            }
            Divider()
            Button("Delete", role: .destructive) {
                deleteAsset(asset)
            }
        }
    }

    @ViewBuilder
    private func assetPreview(_ asset: Asset) -> some View {
        switch asset.assetType {
        case .color:
            if let colorHex = asset.colorHex {
                Color(hex: colorHex)
            } else {
                Color.gray
            }
        case .image:
            Image(systemName: "photo")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(nsColor: .controlBackgroundColor))
        case .sfSymbol:
            if let symbolName = asset.sfSymbolName {
                Image(systemName: symbolName)
                    .font(.system(size: 16))
                    .foregroundStyle(.primary)
            } else {
                Image(systemName: "star")
                    .foregroundStyle(.secondary)
            }
        case .customFont:
            Text("Aa")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.primary)
        }
    }

    // MARK: - Filtered Assets

    private var filteredAssets: [Asset] {
        var result = currentProjectAssets

        if let category = selectedCategory {
            result = result.filter { $0.assetType == category }
        }

        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }

        return result
    }

    private var currentProjectAssets: [Asset] {
        guard let project = appStore.currentProject else { return [] }
        return assets.filter { $0.project?.id == project.id }
    }

    // MARK: - Actions

    private func deleteAsset(_ asset: Asset) {
        modelContext.delete(asset)
        try? modelContext.save()
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    AssetsLibraryView()
        .environment(AppStore())
        .frame(width: 250, height: 500)
}
