//
//  SelectionStore.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation
import SwiftData

/// Tracks selection state across the application
@Observable
final class SelectionStore {
    // MARK: - File Selection

    /// Currently selected file (View, DataModel, or Query)
    var selectedFileId: UUID?
    var selectedFileType: FileType?

    // MARK: - Block Selection (for View Editor)

    /// Currently selected block in the view editor
    var selectedBlockId: UUID?

    /// Multiple selected blocks (for multi-select operations)
    var selectedBlockIds: Set<UUID> = []

    // MARK: - Property/Function Selection

    /// Selected property in inspector
    var selectedPropertyId: UUID?

    /// Selected function in inspector
    var selectedFunctionId: UUID?

    // MARK: - Model Selection (for Data Model Editor)

    /// Selected model version
    var selectedVersionId: UUID?

    /// Selected model property
    var selectedModelPropertyId: UUID?

    /// Selected model relationship
    var selectedRelationshipId: UUID?

    // MARK: - Logic Block Selection (for Query Editor)

    /// Selected logic block in workflow editor
    var selectedLogicBlockId: UUID?

    /// Multiple selected logic blocks
    var selectedLogicBlockIds: Set<UUID> = []

    // MARK: - Computed Properties

    var hasFileSelection: Bool {
        selectedFileId != nil
    }

    var hasBlockSelection: Bool {
        selectedBlockId != nil
    }

    var hasMultipleBlocksSelected: Bool {
        selectedBlockIds.count > 1
    }

    var hasLogicBlockSelection: Bool {
        selectedLogicBlockId != nil
    }

    // MARK: - File Type

    enum FileType: String, Sendable {
        case view
        case dataModel
        case query
    }

    // MARK: - Selection Methods

    func selectFile(id: UUID, type: FileType) {
        selectedFileId = id
        selectedFileType = type
        clearBlockSelection()
        clearPropertySelection()
        clearModelSelection()
        clearLogicBlockSelection()
    }

    func clearFileSelection() {
        selectedFileId = nil
        selectedFileType = nil
        clearBlockSelection()
        clearPropertySelection()
        clearModelSelection()
        clearLogicBlockSelection()
    }

    // MARK: - Block Selection

    func selectBlock(id: UUID, addToSelection: Bool = false) {
        if addToSelection {
            selectedBlockIds.insert(id)
            selectedBlockId = id
        } else {
            selectedBlockIds = [id]
            selectedBlockId = id
        }
    }

    func deselectBlock(id: UUID) {
        selectedBlockIds.remove(id)
        if selectedBlockId == id {
            selectedBlockId = selectedBlockIds.first
        }
    }

    func clearBlockSelection() {
        selectedBlockId = nil
        selectedBlockIds.removeAll()
    }

    func isBlockSelected(_ id: UUID) -> Bool {
        selectedBlockIds.contains(id)
    }

    // MARK: - Property/Function Selection

    func selectProperty(id: UUID) {
        selectedPropertyId = id
        selectedFunctionId = nil
    }

    func selectFunction(id: UUID) {
        selectedFunctionId = id
        selectedPropertyId = nil
    }

    func clearPropertySelection() {
        selectedPropertyId = nil
        selectedFunctionId = nil
    }

    // MARK: - Model Selection

    func selectVersion(id: UUID) {
        selectedVersionId = id
        selectedModelPropertyId = nil
        selectedRelationshipId = nil
    }

    func selectModelProperty(id: UUID) {
        selectedModelPropertyId = id
        selectedRelationshipId = nil
    }

    func selectRelationship(id: UUID) {
        selectedRelationshipId = id
        selectedModelPropertyId = nil
    }

    func clearModelSelection() {
        selectedVersionId = nil
        selectedModelPropertyId = nil
        selectedRelationshipId = nil
    }

    // MARK: - Logic Block Selection

    func selectLogicBlock(id: UUID, addToSelection: Bool = false) {
        if addToSelection {
            selectedLogicBlockIds.insert(id)
            selectedLogicBlockId = id
        } else {
            selectedLogicBlockIds = [id]
            selectedLogicBlockId = id
        }
    }

    func deselectLogicBlock(id: UUID) {
        selectedLogicBlockIds.remove(id)
        if selectedLogicBlockId == id {
            selectedLogicBlockId = selectedLogicBlockIds.first
        }
    }

    func clearLogicBlockSelection() {
        selectedLogicBlockId = nil
        selectedLogicBlockIds.removeAll()
    }

    func isLogicBlockSelected(_ id: UUID) -> Bool {
        selectedLogicBlockIds.contains(id)
    }

    // MARK: - Clear All

    func clearAll() {
        clearFileSelection()
    }
}
