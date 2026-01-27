//
//  ContentEditorView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// Main content editor that switches between different editor types based on selection
struct ContentEditorView: View {
    @Environment(AppStore.self) private var appStore
    @Environment(\.titleBarMetrics) private var titleBarMetrics

    @State private var isPaletteVisible = true

    var body: some View {
        VStack(spacing: 0) {
            // Content toolbar (positioned in title bar area)
            contentToolbar
                .frame(height: titleBarMetrics.height)

            Divider()

            // Editor content
            Group {
                if let fileType = appStore.selectedFileType {
                    switch fileType {
                    case .view:
                        ViewEditorView(isPaletteVisible: $isPaletteVisible)
                    case .dataModel:
                        ModelEditorPlaceholder()
                    case .query:
                        QueryEditorPlaceholder()
                    }
                } else {
                    WelcomeView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    // MARK: - Content Toolbar

    private var contentToolbar: some View {
        HStack(spacing: 8) {
            // Project name
            if let project = appStore.currentProject {
                Text(project.name)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.primary)
            }

            Spacer()

            // View editor controls (only show when editing a view)
            if appStore.selectedFileType == .view {
                viewEditorControls
            }
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 12)
        .background(.bar)
    }

    // MARK: - View Editor Controls

    private var viewEditorControls: some View {
        HStack(spacing: 8) {
            // Toggle palette
            ToolbarButton(
                icon: "sidebar.left",
                action: { isPaletteVisible.toggle() },
                isActive: isPaletteVisible,
                helpText: "Toggle Block Palette"
            )

            ToolbarDivider()

            // Device selector
            DeviceSelectionBar(
                selectedDevice: Binding(
                    get: { appStore.editor.selectedDevice },
                    set: { appStore.editor.selectedDevice = $0 }
                )
            )

            ToolbarDivider()

            // Zoom controls
            ToolbarSegment {
                ToolbarButton(
                    icon: "minus.magnifyingglass",
                    action: { appStore.editor.zoomOut() },
                    helpText: "Zoom Out"
                )

                ToolbarLabel(text: "\(Int(appStore.editor.zoomLevel * 100))%")

                ToolbarButton(
                    icon: "plus.magnifyingglass",
                    action: { appStore.editor.zoomIn() },
                    helpText: "Zoom In"
                )
            }

            ToolbarButton(
                icon: "1.magnifyingglass",
                action: { appStore.editor.resetZoom() },
                helpText: "Reset Zoom"
            )

            ToolbarDivider()

            // Grid toggle
            ToolbarButton(
                icon: "grid",
                action: { appStore.editor.showGrid.toggle() },
                isActive: appStore.editor.showGrid,
                helpText: "Toggle Grid"
            )
        }
    }
}

// MARK: - Placeholder Views (to be implemented in later phases)

/// Placeholder for Model Editor (Phase 8)
private struct ModelEditorPlaceholder: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "tablecells")
                .font(.system(size: 48))
                .foregroundStyle(.tertiary)

            Text("Model Editor")
                .font(.title2)
                .foregroundStyle(.secondary)

            Text("Will be implemented in Phase 8")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(nsColor: .windowBackgroundColor))
    }
}

/// Placeholder for Query Editor (Phase 9)
private struct QueryEditorPlaceholder: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "function")
                .font(.system(size: 48))
                .foregroundStyle(.tertiary)

            Text("Query Editor")
                .font(.title2)
                .foregroundStyle(.secondary)

            Text("Will be implemented in Phase 9")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(nsColor: .windowBackgroundColor))
    }
}

#Preview {
    ContentEditorView()
        .environment(AppStore())
        .frame(width: 600, height: 400)
}
