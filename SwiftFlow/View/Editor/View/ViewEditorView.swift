//
//  ViewEditorView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI
import SwiftData

/// Main view editor container with palette and canvas
struct ViewEditorView: View {
    @Environment(AppStore.self) private var appStore
    @Environment(\.modelContext) private var modelContext

    @State private var isPaletteVisible = true
    @State private var paletteWidth: CGFloat = 220

    var body: some View {
        VStack(spacing: 0) {
            // Custom toolbar
            editorToolbar

            Divider()

            // Main content
            HStack(spacing: 0) {
                // Block palette (left side)
                if isPaletteVisible {
                    BlockPaletteView()
                        .frame(width: paletteWidth)

                    Divider()
                }

                // Main canvas area
                ZStack {
                    // Grid background
                    GridBackgroundView()

                    // Block tree visualization
                    if let viewFile = currentViewFile {
                        BlockCanvasView(viewFile: viewFile)
                    } else {
                        emptyCanvasState
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Color(nsColor: .windowBackgroundColor))
    }

    // MARK: - Editor Toolbar

    private var editorToolbar: some View {
        CustomToolbar {
            // Toggle palette
            ToolbarButton(
                icon: "sidebar.left",
                action: { isPaletteVisible.toggle() },
                isActive: isPaletteVisible,
                helpText: "Toggle Block Palette"
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

            ToolbarSpacer()
        }
    }

    // MARK: - Current View File

    private var currentViewFile: ViewFile? {
        guard let fileId = appStore.selectedFileId,
              appStore.selectedFileType == .view else {
            return nil
        }

        let descriptor = FetchDescriptor<ViewFile>(
            predicate: #Predicate { $0.id == fileId }
        )

        return try? modelContext.fetch(descriptor).first
    }

    // MARK: - Empty State

    private var emptyCanvasState: some View {
        VStack(spacing: 16) {
            Image(systemName: "square.dashed")
                .font(.system(size: 48))
                .foregroundStyle(.tertiary)

            Text("No View Selected")
                .font(.title3)
                .foregroundStyle(.secondary)

            Text("Select a view file from the sidebar")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
    }
}

#Preview {
    ViewEditorView()
        .environment(AppStore())
        .frame(width: 800, height: 600)
}
