//
//  DataModel.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation
import SwiftData

/// Represents a SwiftData model definition in the project
@Model
final class DataModel {
    @Attribute(.unique) var id: UUID
    var name: String
    var createdAt: Date
    var modifiedAt: Date

    // Relationship to project
    var project: Project?

    // Version history for migrations
    @Relationship(deleteRule: .cascade, inverse: \ModelVersion.dataModel)
    var versions: [ModelVersion]?

    // Current active version
    var currentVersionId: UUID?

    init(
        id: UUID = UUID(),
        name: String
    ) {
        self.id = id
        self.name = name
        self.createdAt = Date()
        self.modifiedAt = Date()
        self.versions = []
    }

    // MARK: - Version Management

    var sortedVersions: [ModelVersion] {
        (versions ?? []).sorted { $0.versionNumber < $1.versionNumber }
    }

    var currentVersion: ModelVersion? {
        guard let currentId = currentVersionId else {
            return sortedVersions.last
        }
        return versions?.first { $0.id == currentId }
    }

    var latestVersion: ModelVersion? {
        sortedVersions.last
    }

    var nextVersionNumber: Int {
        (sortedVersions.last?.versionNumber ?? 0) + 1
    }

    func addVersion(_ version: ModelVersion) {
        version.dataModel = self
        if versions == nil {
            versions = []
        }
        versions?.append(version)
        currentVersionId = version.id
        markModified()
    }

    func createNewVersion(basedOn existingVersion: ModelVersion? = nil) -> ModelVersion {
        let newVersion = ModelVersion(
            versionNumber: nextVersionNumber
        )

        // Copy properties and relationships from existing version
        if let existing = existingVersion ?? currentVersion {
            for prop in existing.sortedProperties {
                let newProp = ModelProperty(
                    name: prop.name,
                    typeDefinition: prop.typeDefinition,
                    isOptional: prop.isOptional,
                    isUnique: prop.isUnique,
                    defaultValue: prop.defaultValue,
                    isComputed: prop.isComputed,
                    sortOrder: prop.sortOrder
                )
                newVersion.addProperty(newProp)
            }

            for rel in existing.sortedRelationships {
                let newRel = ModelRelationship(
                    name: rel.name,
                    relationshipType: rel.relationshipType,
                    targetModelId: rel.targetModelId,
                    targetModelName: rel.targetModelName,
                    deleteRule: rel.deleteRule,
                    inverseName: rel.inverseName,
                    sortOrder: rel.sortOrder
                )
                newVersion.addRelationship(newRel)
            }
        }

        addVersion(newVersion)
        return newVersion
    }

    func setCurrentVersion(_ version: ModelVersion) {
        currentVersionId = version.id
        markModified()
    }

    // MARK: - Update

    func markModified() {
        modifiedAt = Date()
        project?.markModified()
    }
}

