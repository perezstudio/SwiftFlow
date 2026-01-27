//
//  ProjectStore.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation
import SwiftData

/// Manages project CRUD operations
@Observable
final class ProjectStore {
    // MARK: - Properties

    /// The model context for SwiftData operations
    private var modelContext: ModelContext?

    /// Currently loaded project
    private(set) var currentProject: Project?

    /// Loading state
    private(set) var isLoading: Bool = false

    /// Error state
    private(set) var lastError: Error?

    // MARK: - Initialization

    func configure(with modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Project CRUD

    func createProject(name: String) throws -> Project {
        guard let modelContext else {
            throw ProjectStoreError.notConfigured
        }

        let project = Project(name: name)
        modelContext.insert(project)
        try modelContext.save()

        currentProject = project
        return project
    }

    func loadProject(_ project: Project) {
        currentProject = project
    }

    func closeProject() {
        currentProject = nil
    }

    func loadProject(id: UUID) throws {
        guard let modelContext else {
            throw ProjectStoreError.notConfigured
        }

        let descriptor = FetchDescriptor<Project>(
            predicate: #Predicate { $0.id == id }
        )

        guard let project = try modelContext.fetch(descriptor).first else {
            throw ProjectStoreError.projectNotFound
        }

        currentProject = project
    }

    func saveCurrentProject() throws {
        guard let modelContext else {
            throw ProjectStoreError.notConfigured
        }

        currentProject?.markModified()
        try modelContext.save()
    }

    func deleteProject(_ project: Project) throws {
        guard let modelContext else {
            throw ProjectStoreError.notConfigured
        }

        if currentProject?.id == project.id {
            currentProject = nil
        }

        modelContext.delete(project)
        try modelContext.save()
    }

    func fetchAllProjects() throws -> [Project] {
        guard let modelContext else {
            throw ProjectStoreError.notConfigured
        }

        let descriptor = FetchDescriptor<Project>(
            sortBy: [SortDescriptor(\.modifiedAt, order: .reverse)]
        )

        return try modelContext.fetch(descriptor)
    }

    // MARK: - View File Operations

    func createViewFile(name: String) throws -> ViewFile {
        guard let project = currentProject else {
            throw ProjectStoreError.noProjectLoaded
        }
        guard let modelContext else {
            throw ProjectStoreError.notConfigured
        }

        let viewFile = ViewFile(name: name)
        modelContext.insert(viewFile)
        project.addViewFile(viewFile)

        try modelContext.save()
        return viewFile
    }

    func deleteViewFile(_ viewFile: ViewFile) throws {
        guard let modelContext else {
            throw ProjectStoreError.notConfigured
        }

        currentProject?.removeViewFile(viewFile)
        modelContext.delete(viewFile)
        try modelContext.save()
    }

    func fetchViewFile(id: UUID) throws -> ViewFile? {
        guard let modelContext else {
            throw ProjectStoreError.notConfigured
        }

        let descriptor = FetchDescriptor<ViewFile>(
            predicate: #Predicate { $0.id == id }
        )

        return try modelContext.fetch(descriptor).first
    }

    // MARK: - Data Model Operations

    func createDataModel(name: String) throws -> DataModel {
        guard let project = currentProject else {
            throw ProjectStoreError.noProjectLoaded
        }
        guard let modelContext else {
            throw ProjectStoreError.notConfigured
        }

        let dataModel = DataModel(name: name)
        modelContext.insert(dataModel)
        project.addDataModel(dataModel)

        // Create initial version
        let version = ModelVersion(versionNumber: 1)
        modelContext.insert(version)
        dataModel.addVersion(version)

        try modelContext.save()
        return dataModel
    }

    func deleteDataModel(_ dataModel: DataModel) throws {
        guard let modelContext else {
            throw ProjectStoreError.notConfigured
        }

        currentProject?.removeDataModel(dataModel)
        modelContext.delete(dataModel)
        try modelContext.save()
    }

    func fetchDataModel(id: UUID) throws -> DataModel? {
        guard let modelContext else {
            throw ProjectStoreError.notConfigured
        }

        let descriptor = FetchDescriptor<DataModel>(
            predicate: #Predicate { $0.id == id }
        )

        return try modelContext.fetch(descriptor).first
    }

    // MARK: - Query File Operations

    func createQueryFile(name: String) throws -> QueryFile {
        guard let project = currentProject else {
            throw ProjectStoreError.noProjectLoaded
        }
        guard let modelContext else {
            throw ProjectStoreError.notConfigured
        }

        let queryFile = QueryFile(name: name)
        modelContext.insert(queryFile)
        project.addQueryFile(queryFile)

        try modelContext.save()
        return queryFile
    }

    func deleteQueryFile(_ queryFile: QueryFile) throws {
        guard let modelContext else {
            throw ProjectStoreError.notConfigured
        }

        currentProject?.removeQueryFile(queryFile)
        modelContext.delete(queryFile)
        try modelContext.save()
    }

    func fetchQueryFile(id: UUID) throws -> QueryFile? {
        guard let modelContext else {
            throw ProjectStoreError.notConfigured
        }

        let descriptor = FetchDescriptor<QueryFile>(
            predicate: #Predicate { $0.id == id }
        )

        return try modelContext.fetch(descriptor).first
    }

    // MARK: - View Block Operations

    func createViewBlock(type: ViewBlockType, in viewFile: ViewFile, parent: ViewBlock? = nil) throws -> ViewBlock {
        guard let modelContext else {
            throw ProjectStoreError.notConfigured
        }

        let block = ViewBlock(blockType: type)
        modelContext.insert(block)

        if let parent {
            parent.addChild(block)
        } else {
            // If no parent, this becomes the root block (or child of root if root exists)
            if let existingRoot = viewFile.rootBlock {
                existingRoot.addChild(block)
            } else {
                viewFile.setRootBlock(block)
            }
        }

        try modelContext.save()
        return block
    }

    func deleteViewBlock(_ block: ViewBlock, from viewFile: ViewFile) throws {
        guard let modelContext else {
            throw ProjectStoreError.notConfigured
        }

        if let parent = block.parent {
            parent.removeChild(block)
        } else if viewFile.rootBlock?.id == block.id {
            // This is the root block - clear it
            viewFile.setRootBlock(ViewBlock(blockType: .vStack)) // Replace with empty container
        }

        modelContext.delete(block)
        try modelContext.save()
    }

    // MARK: - Logic Block Operations

    func createLogicBlock(type: LogicBlockType, in function: QueryFunction, parent: LogicBlock? = nil) throws -> LogicBlock {
        guard let modelContext else {
            throw ProjectStoreError.notConfigured
        }

        let block = LogicBlock(blockType: type)
        modelContext.insert(block)

        if let parent {
            parent.addChild(block)
        } else {
            function.addBlock(block)
        }

        try modelContext.save()
        return block
    }

    func deleteLogicBlock(_ block: LogicBlock) throws {
        guard let modelContext else {
            throw ProjectStoreError.notConfigured
        }

        if let parent = block.parentBlock {
            parent.removeChild(block)
        } else {
            block.queryFunction?.removeBlock(block)
            block.viewFunction?.removeBodyBlock(block)
        }

        modelContext.delete(block)
        try modelContext.save()
    }

    // MARK: - Save

    func save() throws {
        guard let modelContext else {
            throw ProjectStoreError.notConfigured
        }

        try modelContext.save()
    }

    // MARK: - Error Handling

    func clearError() {
        lastError = nil
    }
}

// MARK: - Errors

enum ProjectStoreError: LocalizedError {
    case notConfigured
    case noProjectLoaded
    case projectNotFound
    case saveFailed(Error)

    var errorDescription: String? {
        switch self {
        case .notConfigured:
            return "Project store is not configured with a model context"
        case .noProjectLoaded:
            return "No project is currently loaded"
        case .projectNotFound:
            return "Project not found"
        case .saveFailed(let error):
            return "Failed to save: \(error.localizedDescription)"
        }
    }
}
