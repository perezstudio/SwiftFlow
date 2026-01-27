//
//  SidebarView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// Main sidebar container that shows file list and context-specific navigator
struct SidebarView: View {
    @Environment(AppStore.self) private var appStore

    @State private var sidebarSection: SidebarSection = .files

    enum SidebarSection: String, CaseIterable {
        case files = "Files"
        case navigator = "Navigator"
        case assets = "Assets"

        var systemImage: String {
            switch self {
            case .files: return "doc.on.doc"
            case .navigator: return "list.bullet.indent"
            case .assets: return "photo.on.rectangle"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Section picker
            sectionPicker

            Divider()

            // Content based on section
            switch sidebarSection {
            case .files:
                FileSelectorView()
            case .navigator:
                FileNavigatorView()
            case .assets:
                AssetsLibraryView()
            }
        }
        .frame(minWidth: 200)
    }

    private var sectionPicker: some View {
        HStack(spacing: 2) {
            ForEach(SidebarSection.allCases, id: \.self) { section in
                Button(action: { sidebarSection = section }) {
                    Image(systemName: section.systemImage)
                        .font(.system(size: 12))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(sidebarSection == section ? Color.accentColor.opacity(0.15) : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                .buttonStyle(.plain)
                .help(section.rawValue)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
    }
}

#Preview {
    SidebarView()
        .environment(AppStore())
        .frame(width: 250, height: 500)
}
