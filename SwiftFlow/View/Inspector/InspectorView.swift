//
//  InspectorView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI
import SwiftData

/// Main inspector panel that switches content based on selection
struct InspectorView: View {
    @Environment(AppStore.self) private var appStore
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 0) {
            // Top spacer for window controls area
            Spacer()
                .frame(height: 52)

            Divider()

            // Inspector title header
            inspectorHeader

            Divider()

            // Content based on selection
            ScrollView {
                LazyVStack(spacing: 0) {
                    inspectorContent
                }
            }
        }
        .background(Color(nsColor: .windowBackgroundColor))
    }

    // MARK: - Header

    private var inspectorHeader: some View {
        HStack {
            Text(headerTitle)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.secondary)

            Spacer()

            if appStore.selectedBlockId != nil {
                Menu {
                    Button("Copy") { }
                    Button("Paste Style") { }
                    Divider()
                    Button("Reset to Defaults") { }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                .menuStyle(.borderlessButton)
                .menuIndicator(.hidden)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(nsColor: .separatorColor).opacity(0.3))
    }

    private var headerTitle: String {
        if appStore.selectedBlockId != nil {
            return "Block Inspector"
        } else if appStore.selectedFileId != nil {
            return "File Inspector"
        } else {
            return "Inspector"
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var inspectorContent: some View {
        if let blockId = appStore.selectedBlockId {
            // Block selected - show block inspector
            if let block = fetchBlock(id: blockId) {
                BlockInspectorView(block: block)
            } else {
                EmptyInspectorView(message: "Block not found")
            }
        } else if let fileId = appStore.selectedFileId {
            // File selected - show file inspector
            FileInspectorView(fileId: fileId, fileType: appStore.selectedFileType ?? .view)
        } else {
            // Nothing selected
            EmptyInspectorView(message: "No Selection")
        }
    }

    // MARK: - Data Fetching

    private func fetchBlock(id: UUID) -> ViewBlock? {
        let descriptor = FetchDescriptor<ViewBlock>(
            predicate: #Predicate { $0.id == id }
        )
        return try? modelContext.fetch(descriptor).first
    }
}

#Preview {
    InspectorView()
        .environment(AppStore())
        .frame(width: 280, height: 500)
}
