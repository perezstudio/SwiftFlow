//
//  AppStore.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation
import SwiftData

/// Central store coordinator that manages all app state
@Observable
final class AppStore {
    // MARK: - Sub-stores

    let project: ProjectStore
    let selection: SelectionStore
    let editor: EditorStore
    let clipboard: ClipboardStore
    let undo: UndoStore
    let drag: DragCoordinator

    // MARK: - App State

    /// Whether the app is fully initialized
    private(set) var isInitialized: Bool = false

    /// Current sidebar width
    var sidebarWidth: CGFloat = 250

    /// Current inspector width
    var inspectorWidth: CGFloat = 300

    /// Whether sidebar is visible
    var isSidebarVisible: Bool = true

    /// Whether inspector is visible
    var isInspectorVisible: Bool = true

    // MARK: - Initialization

    init() {
        self.project = ProjectStore()
        self.selection = SelectionStore()
        self.editor = EditorStore()
        self.clipboard = ClipboardStore()
        self.undo = UndoStore()
        self.drag = DragCoordinator()
    }

    /// Configure the store with a model context
    func configure(with modelContext: ModelContext) {
        project.configure(with: modelContext)
        isInitialized = true
    }

    // MARK: - Convenience Accessors

    var currentProject: Project? {
        project.currentProject
    }

    var selectedFileId: UUID? {
        selection.selectedFileId
    }

    var selectedFileType: SelectionStore.FileType? {
        selection.selectedFileType
    }

    var selectedBlockId: UUID? {
        selection.selectedBlockId
    }

    // MARK: - File Selection Helpers

    func selectedViewFile() throws -> ViewFile? {
        guard let fileId = selection.selectedFileId,
              selection.selectedFileType == .view else {
            return nil
        }
        return try project.fetchViewFile(id: fileId)
    }

    func selectedDataModel() throws -> DataModel? {
        guard let fileId = selection.selectedFileId,
              selection.selectedFileType == .dataModel else {
            return nil
        }
        return try project.fetchDataModel(id: fileId)
    }

    func selectedQueryFile() throws -> QueryFile? {
        guard let fileId = selection.selectedFileId,
              selection.selectedFileType == .query else {
            return nil
        }
        return try project.fetchQueryFile(id: fileId)
    }

    // MARK: - Project Management

    /// Sets the current project and opens it in the editor
    func setCurrentProject(_ newProject: Project) {
        project.loadProject(newProject)
        selection.clearAll()
    }

    /// Closes the current project and returns to the starting view
    func closeCurrentProject() {
        project.closeProject()
        selection.clearAll()
        editor.reset()
    }

    // MARK: - Panel Visibility

    func toggleSidebar() {
        isSidebarVisible.toggle()
    }

    func toggleInspector() {
        isInspectorVisible.toggle()
    }

    func showSidebar() {
        isSidebarVisible = true
    }

    func hideSidebar() {
        isSidebarVisible = false
    }

    func showInspector() {
        isInspectorVisible = true
    }

    func hideInspector() {
        isInspectorVisible = false
    }

    // MARK: - Reset

    func reset() {
        selection.clearAll()
        editor.reset()
        clipboard.clear()
        undo.clear()
        drag.cancelDrag()
    }

    // MARK: - Undo Registration Helpers

    func registerUndoableAction(
        name: String,
        perform: @escaping @Sendable () -> Void,
        undo undoAction: @escaping @Sendable () -> Void
    ) {
        // Perform the action
        perform()

        // Register for undo
        undo.registerUndo(
            name: name,
            undo: undoAction,
            redo: perform
        )
    }

    // MARK: - Common Operations

    func createViewFile(name: String) throws {
        let viewFile = try project.createViewFile(name: name)
        selection.selectFile(id: viewFile.id, type: .view)
    }

    func createDataModel(name: String) throws {
        let dataModel = try project.createDataModel(name: name)
        selection.selectFile(id: dataModel.id, type: .dataModel)
    }

    func createQueryFile(name: String) throws {
        let queryFile = try project.createQueryFile(name: name)
        selection.selectFile(id: queryFile.id, type: .query)
    }

    func deleteSelectedFile() throws {
        guard let fileId = selection.selectedFileId,
              let fileType = selection.selectedFileType else {
            return
        }

        switch fileType {
        case .view:
            if let viewFile = try project.fetchViewFile(id: fileId) {
                try project.deleteViewFile(viewFile)
            }
        case .dataModel:
            if let dataModel = try project.fetchDataModel(id: fileId) {
                try project.deleteDataModel(dataModel)
            }
        case .query:
            if let queryFile = try project.fetchQueryFile(id: fileId) {
                try project.deleteQueryFile(queryFile)
            }
        }

        selection.clearFileSelection()
    }

    // MARK: - Block Operations

    func addViewBlock(type: ViewBlockType) throws {
        guard let viewFile = try selectedViewFile() else { return }

        let parentBlock: ViewBlock?
        if let selectedBlockId = selection.selectedBlockId {
            parentBlock = viewFile.allBlocks().first { $0.id == selectedBlockId }
        } else {
            parentBlock = nil
        }

        let newBlock = try project.createViewBlock(type: type, in: viewFile, parent: parentBlock)
        selection.selectBlock(id: newBlock.id)
    }

    func deleteSelectedBlock() throws {
        guard let viewFile = try selectedViewFile(),
              let blockId = selection.selectedBlockId,
              let block = viewFile.allBlocks().first(where: { $0.id == blockId }) else {
            return
        }

        try project.deleteViewBlock(block, from: viewFile)
        selection.clearBlockSelection()
    }
}

// MARK: - Environment Key

import SwiftUI

struct AppStoreKey: EnvironmentKey {
    static let defaultValue: AppStore = AppStore()
}

extension EnvironmentValues {
    var appStore: AppStore {
        get { self[AppStoreKey.self] }
        set { self[AppStoreKey.self] = newValue }
    }
}
