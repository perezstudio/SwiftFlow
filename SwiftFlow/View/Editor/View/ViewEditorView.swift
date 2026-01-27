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
        .background(Color(nsColor: .windowBackgroundColor))
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                // Toggle palette
                Button(action: { isPaletteVisible.toggle() }) {
                    Image(systemName: isPaletteVisible ? "sidebar.left" : "sidebar.left")
                        .symbolVariant(isPaletteVisible ? .fill : .none)
                }
                .help("Toggle Block Palette")

                Divider()

                // Zoom controls
                Button(action: { appStore.editor.zoomOut() }) {
                    Image(systemName: "minus.magnifyingglass")
                }
                .help("Zoom Out")

                Text("\(Int(appStore.editor.zoomLevel * 100))%")
                    .font(.system(size: 11, design: .monospaced))
                    .frame(width: 40)

                Button(action: { appStore.editor.zoomIn() }) {
                    Image(systemName: "plus.magnifyingglass")
                }
                .help("Zoom In")

                Button(action: { appStore.editor.resetZoom() }) {
                    Image(systemName: "1.magnifyingglass")
                }
                .help("Reset Zoom")

                Divider()

                // Grid toggle
                Button(action: { appStore.editor.showGrid.toggle() }) {
                    Image(systemName: "grid")
                        .symbolVariant(appStore.editor.showGrid ? .fill : .none)
                }
                .help("Toggle Grid")
            }
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
