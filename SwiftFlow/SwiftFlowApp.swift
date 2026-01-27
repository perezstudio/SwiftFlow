//
//  SwiftFlowApp.swift
//  SwiftFlow
//
//  Created by Keviruchis on 1/26/26.
//

import SwiftUI
import SwiftData

@main
struct SwiftFlowApp: App {
    /// The shared app store instance
    @State private var appStore = AppStore()

    /// SwiftData model container
    let modelContainer: ModelContainer = ModelContainer.swiftFlow

    var body: some Scene {
        WindowGroup {
            Group {
                if appStore.currentProject != nil {
                    EditorView()
                } else {
                    StartingView()
                }
            }
            .environment(appStore)
            .environment(\.appStore, appStore)
            .modelContainer(modelContainer)
            .onAppear {
                // Configure the app store with the model context
                let context = modelContainer.mainContext
                appStore.configure(with: context)
            }
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            // Edit menu commands
            CommandGroup(after: .undoRedo) {
                Button(appStore.undo.undoMenuTitle) {
                    appStore.undo.undo()
                }
                .keyboardShortcut("z", modifiers: .command)
                .disabled(!appStore.undo.canUndo)

                Button(appStore.undo.redoMenuTitle) {
                    appStore.undo.redo()
                }
                .keyboardShortcut("z", modifiers: [.command, .shift])
                .disabled(!appStore.undo.canRedo)
            }

            // View menu commands
            CommandGroup(after: .sidebar) {
                Button(appStore.isSidebarVisible ? "Hide Sidebar" : "Show Sidebar") {
                    appStore.toggleSidebar()
                }
                .keyboardShortcut("s", modifiers: [.command, .control])

                Button(appStore.isInspectorVisible ? "Hide Inspector" : "Show Inspector") {
                    appStore.toggleInspector()
                }
                .keyboardShortcut("i", modifiers: [.command, .option])

                Divider()

                Button("Zoom In") {
                    appStore.editor.zoomIn()
                }
                .keyboardShortcut("+", modifiers: .command)

                Button("Zoom Out") {
                    appStore.editor.zoomOut()
                }
                .keyboardShortcut("-", modifiers: .command)

                Button("Reset Zoom") {
                    appStore.editor.resetZoom()
                }
                .keyboardShortcut("0", modifiers: .command)
            }
        }
    }
}
