//
//  EditorView.swift
//  SwiftFlow
//
//  Created by Keviruchis on 1/26/26.
//

import SwiftUI

/// Main editor view with sidebar, content editor, and inspector
struct EditorView: View {
    @Environment(AppStore.self) private var appStore

    var body: some View {
        VStack(spacing: 0) {
            // Main app toolbar
            mainToolbar

            Divider()

            // Three-panel layout
            SplitViewContainer {
                // Sidebar
                SidebarView()
            } content: {
                // Content Editor
                ContentEditorView()
            } detail: {
                // Inspector
                InspectorView()
            }
            .sidebarWidth(min: 200, max: 350)
            .contentMinWidth(400)
            .detailMinWidth(280)
        }
        .ignoresSafeArea()
    }

    // MARK: - Main Toolbar

    private var mainToolbar: some View {
        CustomToolbar {
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

            ToolbarSpacer()

            // Toggle sidebar
            ToolbarButton(
                icon: "sidebar.leading",
                action: { appStore.toggleSidebar() },
                isActive: appStore.isSidebarVisible,
                helpText: "Toggle Sidebar"
            )

            // Toggle inspector
            ToolbarButton(
                icon: "sidebar.trailing",
                action: { appStore.toggleInspector() },
                isActive: appStore.isInspectorVisible,
                helpText: "Toggle Inspector"
            )
        }
    }
}

#Preview {
    EditorView()
        .environment(AppStore())
}
