//
//  ModelVersion.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation
import SwiftData

/// Represents a version of a SwiftData model schema
@Model
final class ModelVersion {
    @Attribute(.unique) var id: UUID
    var versionNumber: Int
    var createdAt: Date
    var migrationNotes: String?

    // Relationship to data model
    var dataModel: DataModel?

    // Properties in this version
    @Relationship(deleteRule: .cascade, inverse: \ModelProperty.modelVersion)
    var properties: [ModelProperty]?

    // Relationships in this version
    @Relationship(deleteRule: .cascade, inverse: \ModelRelationship.sourceVersion)
    var relationships: [ModelRelationship]?

    init(
        id: UUID = UUID(),
        versionNumber: Int,
        migrationNotes: String? = nil
    ) {
        self.id = id
        self.versionNumber = versionNumber
        self.createdAt = Date()
        self.migrationNotes = migrationNotes
        self.properties = []
        self.relationships = []
    }

    // MARK: - Properties

    var sortedProperties: [ModelProperty] {
        (properties ?? []).sorted { $0.sortOrder < $1.sortOrder }
    }

    var storedProperties: [ModelProperty] {
        sortedProperties.filter { !$0.isComputed }
    }

    var computedProperties: [ModelProperty] {
        sortedProperties.filter { $0.isComputed }
    }

    func addProperty(_ property: ModelProperty) {
        property.modelVersion = self
        property.sortOrder = (properties ?? []).count
        if properties == nil {
            properties = []
        }
        properties?.append(property)
    }

    func removeProperty(_ property: ModelProperty) {
        properties?.removeAll { $0.id == property.id }
        reindexProperties()
    }

    func moveProperty(from source: Int, to destination: Int) {
        let sorted = sortedProperties
        guard source >= 0, source < sorted.count,
              destination >= 0, destination <= sorted.count else { return }

        var mutableSorted = sorted
        let item = mutableSorted.remove(at: source)
        mutableSorted.insert(item, at: destination > source ? destination - 1 : destination)

        for (index, prop) in mutableSorted.enumerated() {
            prop.sortOrder = index
        }
    }

    private func reindexProperties() {
        for (index, prop) in sortedProperties.enumerated() {
            prop.sortOrder = index
        }
    }

    // MARK: - Relationships

    var sortedRelationships: [ModelRelationship] {
        (relationships ?? []).sorted { $0.sortOrder < $1.sortOrder }
    }

    func addRelationship(_ relationship: ModelRelationship) {
        relationship.sourceVersion = self
        relationship.sortOrder = (relationships ?? []).count
        if relationships == nil {
            relationships = []
        }
        relationships?.append(relationship)
    }

    func removeRelationship(_ relationship: ModelRelationship) {
        relationships?.removeAll { $0.id == relationship.id }
        reindexRelationships()
    }

    private func reindexRelationships() {
        for (index, rel) in sortedRelationships.enumerated() {
            rel.sortOrder = index
        }
    }

    // MARK: - Lookup

    func property(named name: String) -> ModelProperty? {
        properties?.first { $0.name == name }
    }

    func relationship(named name: String) -> ModelRelationship? {
        relationships?.first { $0.name == name }
    }

    // MARK: - Display

    var displayName: String {
        "Version \(versionNumber)"
    }

    var summary: String {
        let propCount = properties?.count ?? 0
        let relCount = relationships?.count ?? 0
        return "\(propCount) properties, \(relCount) relationships"
    }
}
