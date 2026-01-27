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

    var body: some View {
        VStack(spacing: 0) {
            // Content toolbar
            contentToolbar

            Divider()

            // Editor content
            Group {
                if let fileType = appStore.selectedFileType {
                    switch fileType {
                    case .view:
                        ViewEditorView()
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
            // Close project button
            ToolbarButton(
                icon: "chevron.left",
                action: { appStore.closeCurrentProject() },
                helpText: "Close Project"
            )

            ToolbarDivider()

            // Project name
            if let project = appStore.currentProject {
                Text(project.name)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.primary)
            }

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.top, 6)
        .frame(height: 52)
        .background(Color(nsColor: .windowBackgroundColor))
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
