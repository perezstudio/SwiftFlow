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
        SplitViewContainer {
            // Sidebar
            SidebarView()
        } content: {
            // Content Editor with toolbar
            ContentEditorView()
        } detail: {
            // Inspector
            InspectorView()
        }
        .sidebarWidth(min: 200, max: 350)
        .contentMinWidth(400)
        .detailMinWidth(280)
        .sidebarVisible(appStore.isSidebarVisible)
        .detailVisible(appStore.isInspectorVisible)
        .ignoresSafeArea()
    }
}

#Preview {
    EditorView()
        .environment(AppStore())
}
