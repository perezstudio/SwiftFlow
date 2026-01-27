//
//  ModelRelationship.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation
import SwiftData

/// Represents a relationship between SwiftData models
@Model
final class ModelRelationship {
    @Attribute(.unique) var id: UUID
    var name: String
    var relationshipType: RelationshipType
    var targetModelId: UUID            // References another DataModel
    var targetModelName: String        // Cached name for display
    var deleteRule: DeleteRuleType
    var inverseName: String?           // Name of the inverse relationship
    var sortOrder: Int

    // Relationship to source model version
    var sourceVersion: ModelVersion?

    init(
        id: UUID = UUID(),
        name: String,
        relationshipType: RelationshipType,
        targetModelId: UUID,
        targetModelName: String,
        deleteRule: DeleteRuleType = .nullify,
        inverseName: String? = nil,
        sortOrder: Int = 0
    ) {
        self.id = id
        self.name = name
        self.relationshipType = relationshipType
        self.targetModelId = targetModelId
        self.targetModelName = targetModelName
        self.deleteRule = deleteRule
        self.inverseName = inverseName
        self.sortOrder = sortOrder
    }

    // MARK: - Display

    var displayName: String {
        name
    }

    var typeDisplayName: String {
        switch relationshipType {
        case .oneToOne:
            return targetModelName + "?"
        case .oneToMany, .manyToMany:
            return "[\(targetModelName)]"
        }
    }

    var signature: String {
        "var \(name): \(typeDisplayName)"
    }

    var summary: String {
        var parts: [String] = []
        parts.append(relationshipType.displayName)
        parts.append("→ \(targetModelName)")
        if let inverse = inverseName {
            parts.append("inverse: \(inverse)")
        }
        parts.append(deleteRule.displayName)
        return parts.joined(separator: ", ")
    }

    // MARK: - Code Generation

    func toSwiftCode(indent: String = "    ") -> String {
        var lines: [String] = []

        // Build @Relationship attribute
        var relationshipParts: [String] = []

        relationshipParts.append("deleteRule: \(deleteRule.swiftDataCode)")

        if let inverse = inverseName {
            relationshipParts.append("inverse: \\\(targetModelName).\(inverse)")
        }

        lines.append("\(indent)@Relationship(\(relationshipParts.joined(separator: ", ")))")

        // Property declaration
        let declaration = "\(indent)var \(name): \(typeDisplayName)"
        lines.append(declaration)

        return lines.joined(separator: "\n")
    }
}
